#encoding: UTF-8
class User < ActiveRecord::Base

  PRE_INACTIVE_REMINDER_DATES=[3,7]
  PRE_SUSPEND_REMINDER_DATES=[15,20,25]

  attr_accessor :users_count,:confirm, :require_pwd, :pwd, :new_pwd, :cart_id, :mailing, :matrix_button, :closing, :make_comm, :gen_cart_seed, :ignore_sponsor, :mass, :products, :product_id

  attr_accessible :account_type_id,
                  :person_type_id,
                  :person_nick,
                  :person_name,
                  :cpf,
                  :company_nick,
                  :company_name,
                  :cnpj,
                  :name,
                  :email1,
                  :email2,
                  :mobile,
                  :phone,
                  :password,
                  :password_confirmation,
                  :comes_from_id,
                  :bank_account_attributes,
                  :address_attributes,
                  :confirm, as: :signup

  attr_accessible :person_type_id,
                  :person_nick,
                  :person_name,
                  :cpf,
                  :company_nick,
                  :company_name,
                  :cnpj,
                  :respons_name,
                  :respons_cpf,
                  :rg,
                  :gender_id,
                  :birth,
                  :phone,
                  :mobile,
                  :email2,
                  :pwd,
                  :new_pwd,
                  :comes_from_id,
                  :address_attributes,
                  :bank_account_attributes,as: :office_user

  attr_accessible :bank_account_attributes,
                  :name,
                  :account_type_id, as: :office_networker



  belongs_to :sponsor, :class_name => "User", foreign_key: "sponsor_id", counter_cache: "sponsored_count"
  has_many :sponsored, :class_name => "User", foreign_key: "sponsor_id"


  has_one :visit, dependent: :destroy
  has_one :address, dependent: :destroy
  has_one :bank_account, dependent: :destroy
  has_one :matrix, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :comms, dependent: :destroy
  has_many :comms_free, class_name:"Comm", conditions:{blocked:false,status:0, payment_id:nil}
  has_many :payments, dependent: :destroy

  before_validation :requires, :token_filter, :name_filter, :email_filter, :filter_for_pf_and_pj, :filter_for_cli_and_partner
  before_save :sets_birthday, :maintain_root_users, :set_bloked_at, :activate_networking
  before_create :pos_loads
  after_create :make_the_order, :activate_matrix
  after_create  :emailing
  before_destroy :cannot_destroy_if_it_has_sponsored_someone, :cannot_destroy_an_user_after_activated

  validates :sponsor_id, :presence=>:true, :numericality => :true
  validate :sponsor_id_must_be_included_in_a_list
  validate :sponsor_id_must_be_sponsored_by_a_business_user
  validates :token, :presence=>:true, :length=>{:minimum=>10}
  validates :person_nick, :person_name, presence:true, if: :is_pf?
  validates :company_nick, :company_name, presence:true, if: :is_pj?
#  validates_presence_of :cpf,if: :is_pf?
#  validates_presence_of :cnpj, if: :is_pj?
  validate :clean_cpf_cnpj,:cpf_cnpj_verifications
 # validates_uniqueness_of :cpf, if: :is_pf?
 # validates_uniqueness_of :cnpj, if: :is_pj?

  validates :cpf, :uniqueness=>:true, unless: :is_pf_not_whitelisted?
  validates :cnpj, :uniqueness=>:true, unless: :is_pj_not_whitelisted?

  validates :name, :presence=>:true, :length=>{:in=>3..25},
    :uniqueness=>:true,
    :format=>{:with => /\A[a-zA-Z0-9]+\z/ , :message => "somente letras e numeros são permitidos."}
  validate :name_cannot_blacklisted
  validate :name_must_contain_at_least_one_alpha_char
  validates :email1, :email=>:true, :uniqueness=>:true
  validates :email2, :email=>:true, :if=>"email2.present?"
  validate :email1_must_differ_email2
  validates :mobile, presence: true, on: :create
  validates :password, :presence=>:true,:confirmation=>:true, :length=>{:in=>3..25}
  validates :new_pwd, :presence=>:true,:confirmation=>:true, :length=>{:in=>3..25}, if: "require_pwd==true"


  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :bank_account
  validates :comes_from_id, presence:true
  validates :confirm, :acceptance=>:true, on: :create
  validate :verify_current_pwd, on: :update
  validate :check_about_products, on: :create

  scope :visible, where(status:[0,1,2], blocked:false)

  def check_about_products
    if products && products.any?
      if account_type_id==2
        errors.add(:base, "Para se tornar distribuidor autorizado você deve conter algum \"Kit Distribuidor\" no carrinho.") if products_aval1?
      elsif account_type_id==1
        errors.add(:base, "Para ser apenas cliente você não deve conter nenhum \"Kit Distribuidor\" no carrinho.") if products_aval2?
      end
    end
  end

  def self.there_is_some_of_in_cont? array1, array2
    rest=[]
    array1.sort!
    array1.each do |i|
      rest << i if i.in? array2
    end
    rest.sort!
    array1==rest
  end

  def self.cannot_be_any_in_cont? array1=Product.network_products_ids, array2
    array1.each do |i|
      return true if i.in? array2
    end
    false
  end

  def products_aval1?
    !User.cannot_be_any_in_cont? products
  end

  def products_aval2?
    User.cannot_be_any_in_cont? products
  end

  def get_nick
    if person_type_id==1
      person_nick
    elsif person_type_id==2
      company_nick
    end
  end

  def get_name
    if person_type_id==1
      person_name
    elsif person_type_id==2
      company_name
    end
  end

  def get_login
    if account_type_id==1
      email1
    elsif account_type_id==2
      name
    end
  end

  def get_id
    if person_type_id==1
      cpf
    elsif person_type_id==2
      cnpj
    end
  end

  def visible?
    status.in?([0,1,2]) && blocked==false
  end


  def self.auth username, passwordx
    user=where{((name==username) | (email1==username)) & (password==passwordx) &(blocked==false)}.where(status:[0,1,2]).first
    if user.present?
      user.last_login=Time.now
      user.save validate:false
      user
    else
      nil
    end
  end

  def self.password_recover email
    account = where{((name==email) | (email1==email)) & (blocked==false)}.where(status:[0,1,2]).first


  end

  def self.comes_from_types
    [{id:1, name:"Google"},
     {id:8, name:"Facebook"},
     {id:2, name:"Boca a boca"},
     {id:3, name:"Blog"},
     {id:4, name:"Tv"},
     {id:5, name:"Jornal"},
     {id:6, name:"Rádio"},
     {id:7, name:"Outro"}
    ]
  end

  def comes_from
    src= User.comes_from_types.find{|x| x[:id]==cames_from_id}
    src[:name] if src
  end

  def the_cart
   Cart.find(cart_id) if cart_id.present?
  end

  def my_pending_credit
    comms.where(blocked:false, status:0, payment_id:nil).pluck(:value).sum
  end

  def my_paid_credit
    comms.where(blocked:false, status:1, payment_id:nil).pluck(:value).sum
  end


  def self.get_date_interval from, to
    from=from.to_date
    to=to.to_date
    (from-to).to_i
  end

  def self.reminder_interval_range? day, const
    day.in? const
  end

  def self.pre_inactve_reminder_count day
    case day
    when 7 then 1
    when 3 then 2
    else
      0
    end
  end

  def self.pre_suspend_reminder_count day
    case day
    when 15 then 1
    when 20 then 2
    when 25 then 3
    else
      0
    end
  end

  def self.qualified_members users=nil, sponsored_size=0, start_date, end_date
    start_date=start_date.to_s
    end_date=end_date.to_s
    start_date=Chronic.parse(start_date)
    end_date=Chronic.parse(end_date)
    start_date=start_date.utc.to_date.to_s
    end_date=end_date.utc.to_date.to_s

    if users
      user_ids=User.find_by_sql("select sponsor_id, count(*) as total from users where account_type_id=2 and status=1 and sponsor_id in (#{users.map(&:id).join(",")})  and created_at between '#{start_date}' and '#{end_date}'  group by sponsor_id having count(*) >= #{sponsored_size.to_i}").map(&:sponsor_id)

    else
      user_ids=User.find_by_sql("select sponsor_id, count(*) as total from users where account_type_id=2 and status=1 and created_at between '#{start_date}' and '#{end_date}'  group by sponsor_id having count(*) >= #{sponsored_size.to_i}").map(&:sponsor_id)
    end
    User.where(id:user_ids)
  end

  def self.whats_the_plan? array
    array.each do |x|
      return x if x.in? Product.network_products_ids
    end
    0
  end


  private


  def cannot_destroy_if_it_has_sponsored_someone
    if sponsored_count > 0
      errors.add(:base, "impossível remover usuário que tenha patrocinado outros usuários")
      false
    end
  end

  def cannot_destroy_an_user_after_activated
   rest=orders.where(status:1)
   if rest.any?
     errors.add(:base, "impossível remover usuário que tenha ativado sua conta")
     false
   end
  end

  def is_pj?
    person_type_id==2
  end

  def is_pf?
    person_type_id==1
  end

  def is_pj_not_whitelisted?
    return true if mass
    return true if person_type_id==1
    person_type_id==2 && Multiuser.select(:id).where(cpfcnpj:cnpj).present?
  end

  def is_pf_not_whitelisted?
    return true if mass
    return true if person_type_id==2
    person_type_id==1 && Multiuser.select(:id).where(cpfcnpj:cpf).present?
  end

  def filter_for_cli_and_partner
    if account_type_id==1
      self.name=SecureRandom.hex(5) unless name.present?
    end
  end

  def filter_for_pf_and_pj
    if person_type_id==1
      self.cnpj=nil
      self.company_nick=nil
      self.company_name=nil
      self.respons_name=nil
      self.respons_cpf=nil

    elsif person_type_id==2
      self.cpf=nil
      self.person_nick=nil
      self.person_name=nil
    end
  end

  def clean_cpf_cnpj
      self.cpf=cpf.gsub(/[^0-9]/, "") if cpf && cpf_changed?
      self.respons_cpf=respons_cpf.gsub(/[^0-9]/, "") if respons_cpf &&  respons_cpf_changed?
      self.cnpj=cnpj.gsub(/[^0-9]/, "") if cnpj && cnpj_changed?
  end

  def cpf_cnpj_verifications

    return nil if mass

    if person_type_id==1
      if cpf_changed?
        v=Cpf.new cpf
        errors.add(:cpf,"inválido") unless v.valido?
      end
    elsif person_type_id==2
      if cnpj_changed?
        v=Cnpj.new cnpj
        errors.add(:cnpj,"inválido") unless v.valido?
      end
      if respons_cpf_changed?
        v=Cpf.new respons_cpf
        errors.add(:respons_cpf,"inválido") unless v.valido?
      end
    end

  end


  def sponsor_id_must_be_included_in_a_list
    if ignore_sponsor.nil? && users_count > 0
      ids=User.find_by_sql("select id from users where users.id=#{sponsor_id}")
      unless ids.any?
        errors.add(:sponsor_id, "não é valido")
      end
    end
  end

  def name_cannot_blacklisted
    if name.present?
      bl=BlacklistUsername.find_by_sql("select name from blacklist_usernames").map(&:name)
      if name.in? bl
        errors.add(:name, "#{name} não permitido, tente outro!")
      end
    end
  end

  def name_must_contain_at_least_one_alpha_char
    if (name =~ /[a-zA-Z]/).nil?
      errors.add(:name, "deve conter no minimo 1 letra qualquer de a-z")
    end
  end

  def self.sort
    user=User.order("random()").limit(1).where(account_type_id:2, status:1)
    user.first
  end

  def token_filter
    self.token=SecureRandom.hex(10) unless token.present?
  end

  def pos_loads
    self.build_visit
  end

  def email_filter
    self.email1 = email1.downcase if email1.present?
    self.email2 = email2.downcase if email2.present?
  end

  def name_filter
    self.name = name.downcase if name.present?
  end


  def email1_must_differ_email2
    if email1 == email2 && email2.present?
      errors.add(:base, "email1 e email2 devem ser diferentes")
    end
  end

  def verify_current_pwd
    if require_pwd==true && pwd!=password_was
      errors.add(:pwd, "não confere")
    elsif require_pwd==true && pwd==password_was
      self.password=new_pwd
    end
  end

  def set_bloked_at
    if blocked_changed? && blocked==true
      self.blocked_at=Time.now
    elsif blocked_changed? && blocked==false
      self.blocked_at=nil
    end
  end

  def make_the_order
   if cart_id.present?
      orders.create(price:the_cart.final_price, cart_id:cart_id,mailing:mailing, creating:true, closing:closing, make_comm:make_comm,matrix_button:matrix_button )
   elsif gen_cart_seed.present?
      orders.create( mailing:mailing, creating:true, closing:closing, make_comm:make_comm, gen_cart_seed:gen_cart_seed, matrix_button:matrix_button, product_id:product_id )
   end
  end

  def emailing
    UserMailer.delay.welcome(self) if mailing==true
    UserMailer.delay.sponsored(self) if mailing==true
  end

  def activate_matrix
    if matrix_button.present?
      create_matrix unless matrix.present? && user.account_type_id==2
    end
  end

  def activate_networking
   # if account_type_id_changed? && account_type_id_was==1 && account_type_id==2
   #   question=orders.where(created_at:(Time.now-90.days)..Time.now, status:1).map(&:cart).map(&:qualified_total_price?)
   #   if question.include? true
   #     create_matrix unless matrix.present? && user.account_type_id==2
   #   else
   #     errors.add(:base,"para efetuar esta conversão o usuário deve ter um pedido de acima do valor de #{CFG["min_order_price_to_qualify"].real_contabil} e quitado dentro dos últimos 90 dias")
   #     false
   #   end
   # end
  end

  def sponsor_id_must_be_sponsored_by_a_business_user
    if ignore_sponsor.nil? && users_count > 0 && sponsor.account_type_id!=2
      errors.add(:sponsor_id, "tipo de conta do indicador não aceito.")
    end
  end

  def requires
    self.users_count||=User.count
  end

  def maintain_root_users
    if id==1
      self.ignore_rules=true if ignore_rules!=true
    end
  end

  def sets_birthday
    if birth_changed?
      self.birthday=User.get_birthday_from_time birth.to_time
    end
  end

  def self.get_birthday_from_time time
    [time.month,time.day].join("-")
  end
end
