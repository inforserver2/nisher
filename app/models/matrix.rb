#encoding: UTF-8
class Matrix < ActiveRecord::Base
  belongs_to :user

  belongs_to :upline, :class_name => "Matrix", foreign_key: "upline_id", counter_cache: "downlines_count"
  has_many :downlines, :class_name => "Matrix", foreign_key: "upline_id"

  before_create :requisites
  after_create :add_points_up
  after_update :verify_meta

  before_destroy :cannot_destroy_if_it_has_downlines

  def network deep
    deep=deep.to_i
    if deep >= 1
      list=downlines
    end
    if deep >= 2
      list=collect_sub_downlines list
    end
    if deep >= 3
      list=collect_sub_downlines list
    end
    if deep >= 4
      list=collect_sub_downlines list
    end
#    if deep >= 5
#      list=collect_sub_downlines list
#    end
#    if deep >= 6
#      list=collect_sub_downlines list
#    end
#    if deep >= 7
#      list=collect_sub_downlines list
#    end
#    if deep == 8
#      list=collect_sub_downlines list
#    end
#    unless deep.in? (1..8)
    unless deep.in? (1..4)
      raise "impossible deep"
    end
    list
  end

  def network_collection
      list1=downlines
      list2=collect_sub_downlines list1
      list3=collect_sub_downlines list2
      list4=collect_sub_downlines list3
#      list5=collect_sub_downlines list4
#      list6=collect_sub_downlines list5
#      list7=collect_sub_downlines list6
#      list8=collect_sub_downlines list7
#      { level1:list1, level2:list2, level3:list3, level4:list4, level5:list5, level6:list6, level7:list7 }
      { level1:list1, level2:list2, level3:list3 }
  end


  def network_count deep
    deep=deep.to_i
    if deep >= 1
      list= downlines
      size= downlines_count
    end
    if deep >= 2
      list=collect_sub_downlines list
      size= list.count
    end
    if deep >= 3
      list=collect_sub_downlines list
      size= list.count
    end
    if deep >= 4
      list=collect_sub_downlines list
      size= list.count
    end
#    if deep >= 5
#      list=collect_sub_downlines list
#      size= list.count
#    end
#    if deep >= 6
#      list=collect_sub_downlines list
#      size= list.count
#    end
#    if deep >= 7
#      list=collect_sub_downlines list
#      size= list.count
#    end
#    if deep >= 8
#      list=collect_sub_downlines list
#      size= list.count
#    end
#    unless deep.in? (1..8)
    unless deep.in? (1..4)
      raise "impossible deep"
    end
    size
  end

  def network_count_collection
    level1=network_count 1
    level2=network_count 2
    level3=network_count 3
    level4=network_count 4
#    level5=network_count 5
#    level6=network_count 6
#    level7=network_count 7
#    level8=network_count 8
#    { level1:level1, level2:level2, level3:level3, level4:level4, level5:level5, level6:level6, level7:level7, level8:level8 }
    { level1:level1, level2:level2, level3:level3, level4:level4 }
  end

  def self.sponsors_up matrix_id

    matrix=Matrix.where(id:matrix_id).first
    list=[]
    s1=matrix.upline
    list << s1
    s2=s1.upline
    list << s2
    s3=s2.upline
    list << s3
    s4=s3.upline
    list << s4
#    s5=s4.upline
#    list << s5
#    s6=s5.upline
#    list << s6
#    s7=s6.upline
#    list << s7
#    s8=s7.upline
#    list << s8
    list.map(&:id)
  end

  private

  def verify_meta
    MatrixMailer.delay.meta(self, 1) if level1_changed? && level1==9
    if level2_changed? && level2==81
      self.user.network_plan_id=18 if 18 < user.network_plan_id && user.network_plan_id.in?(Product.network_products_ids)
      MatrixMailer.delay.meta(self, 2)
    end
    if level3_changed? && level3==729
      self.user.network_plan_id=17 if 17 < user.network_plan_id && user.network_plan_id.in?(Product.network_products_ids)
      MatrixMailer.delay.meta(self, 3)
    end
    MatrixMailer.delay.meta(self, 4) if level4_changed? && level4==6561
#    MatrixMailer.delay.meta(self, 5) if level5_changed? && level5==243
#    MatrixMailer.delay.meta(self, 6) if level6_changed? && level6==729
#    MatrixMailer.delay.meta(self, 7) if level7_changed? && level7==2187
#    MatrixMailer.delay.meta(self, 8) if level8_changed? && level8==6561
    user.save validate:false if user.network_plan_id_changed?
  end

  def self.point_sponsors_up matrix
    s1=matrix.upline
    s1.level1+=1; s1.save validate:false
    s2=s1.upline
    s2.level2+=1; s2.save validate:false
    s3=s2.upline
    s3.level3+=1; s3.save validate:false
    s4=s3.upline
    s4.level4+=1; s4.save validate:false
#    s5=s4.upline
#    s5.level5+=1; s5.save validate:false
#    s6=s5.upline
#    s6.level6+=1; s6.save validate:false
#    s7=s6.upline
#    s7.level7+=1; s7.save validate:false
#    s8=s7.upline
#    s8.level8+=1; s8.save validate:false
  end

  def add_points_up
    Matrix.point_sponsors_up self
  end

  def cannot_destroy_if_it_has_downlines
    if downlines_count > 0
      errors.add(:base, "impossível remover matrix que contenha downlines")
      false
    end
  end

  def collect_sub_downlines downlines
    rest=downlines.map(&:downlines).flatten.map(&:id).uniq
    rest=Matrix.where(id:rest)
  end

  def requisites
    if Matrix.count < 1
      self.upline_id=1
    else
      upline=find_a_node_for user.sponsor.matrix
      self.upline_id=upline.id
    end
  end

  def find_a_node_for upline
    #if upline.downlines_count < 3
    if upline.downlines_count < 9
      return upline
    else
      return find_upline_using_downlines(upline.downlines)
    end
  end

#  def find_upline_using_downlines uplines, level
#    subdownlines=[]
#    uplines.each do |upline|
#      if upline.downlines_count < 3
#        return upline
#      end
#      for downline in upline.downlines
#        subdownlines << downline
#      end
#    end
#    level+=1
#    if level > 3
#      find_upline_using_downlines subdownlines, level
#    else
#      raise "cannot found an available upline"
#    end
#  end

  def find_upline_using_downlines uplines
    uplines.each do |upline|
#      if upline.downlines_count < 3
      if upline.downlines_count < 9
        return upline
      end
    end
    subdownlines=uplines.flatten.map(&:downlines)
    find_upline_using_downlines subdownlines.flatten

  end


end
