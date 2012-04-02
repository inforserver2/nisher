#encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#
#   Mayor.create(name: 'Emanuel', city: cities.first)

banks=YAML::load_file("#{Rails.root.to_s}/db/banks.yml")
banks.each {|x| Bank.find_or_create_by_id(x)}

multiusers=YAML::load_file("#{Rails.root.to_s}/db/multiusers.yml")
multiusers.each {|x| Multiuser.find_or_create_by_id(x)}

bank_account_types=YAML::load_file("#{Rails.root.to_s}/db/bank_account_types.yml")
bank_account_types.each {|x| BankAccountType.find_or_create_by_id(x)}


countries=YAML::load_file("#{Rails.root.to_s}/db/countries.yml")
Country.attr_protected.clear
countries.each {|x| Country.find_or_create_by_id(x)}

comm_types=YAML::load_file("#{Rails.root.to_s}/db/comm_types.yml")
CommType.attr_protected.clear
comm_types.each {|x| CommType.find_or_create_by_id(x)}

blacklist_usernames=YAML::load_file("#{Rails.root.to_s}/db/blacklist_usernames.yml")
blacklist_usernames.each {|x| BlacklistUsername.find_or_create_by_name(x)}

product_categories=YAML::load_file("#{Rails.root.to_s}/db/product_categories.yml")
product_categories.each {|x| ProductCategory.find_or_create_by_title(x)}

FreteType.find_or_create_by_name(:name=>"PAC")
FreteType.find_or_create_by_name(:name=>"Sedex")
FreteType.find_or_create_by_name(:name=>"Internacional")

Product.attr_protected.clear
products=YAML::load_file("#{Rails.root.to_s}/db/products.yml")
if Product.count < 1
  products.each {|x|
    Product.find_or_create_by_title(x["title"]){ |p|
       p.attributes=x
       if x["image"].present?
        p.image=File.open([Rails.root,"/public", x["image"]].join)
       end
       p.description= YAML.load x["description"]
       p.save
    }
  }
end

ProductTaste.attr_protected.clear
product_tastes=YAML::load_file("#{Rails.root.to_s}/db/product_tastes.yml")
product_tastes.each {|x| ProductTaste.find_or_create_by_name(x)}

Page.find_or_create_by_name(:name=>"Eventos", :content=>'
<p>
        &nbsp;</p>
<p>
        Todas as noites, &agrave;s 19:30,&nbsp;hor&aacute;rio de&nbsp;Bras&iacute;lia, e nas ter&ccedil;as e quintas as 16 horas,&nbsp;apresenta&ccedil;&atilde;o do nosso Plano&nbsp;de Marketing em sala de conferencias, por distribuidores com profundo conhecimento no sistema.</p>
<p>
        <strong>E ESPECIALMENTE...nas ter&ccedil;as-feiras &agrave;s 19.30 horas, n&atilde;o perca,&nbsp;</strong><strong>TREINAMENTOS DOS PRODUTOS,&nbsp; COM C&Eacute;SAR CEZAR, O BIO-QUIMICO QUE&nbsp;</strong><strong>DESENVOLVEU&nbsp;AS F&Oacute;RMULAS DOS MESMOS.&nbsp;&nbsp;Ele tem profundo conhecimento de&nbsp;nutri&ccedil;&atilde;o e sa&uacute;de.&nbsp;</strong></p>
<p>
        Acesse este endere&ccedil;o:&nbsp;&nbsp;<strong>Sala:</strong>&nbsp;&nbsp;<strong><u><a href="http://www.gvolive.com/conference,69094356">www.gvolive.com/conference,69094356</a></u></strong></p>
<div align="center">
        &nbsp;</div>
<div style="text-align: left; ">
        <br />
        A base do sucesso &eacute; conhecimento mais a&ccedil;&atilde;o!<br />
        Traga todos os seus Amigos e Distribuidores para os eventos e voc&ecirc; ter&aacute; r&aacute;pida ascess&atilde;o em seus&nbsp;neg&oacute;cios.</div>
<p style="text-align: center; ">
        <span style="background-color:#ffff00;">ATEN&Ccedil;&Atilde;O AOS EVENTOS PRESENCIAIS!</span></p>
<p style="text-align: center; ">
        <span style="background-color:#ffff00;">PROMOVA!&nbsp;&nbsp;</span></p>
<p style="text-align: center; ">
        <span style="background-color:#ffff00;">CONVIDE&nbsp;&nbsp;TODOS&nbsp;&nbsp;OS&nbsp;&nbsp;SEUS&nbsp;&nbsp;AMIGOS&nbsp;&nbsp;DA&nbsp;&nbsp;REGI&Atilde;O!</span></p>
<p style="text-align: center; ">
        Esperamos voc&ecirc; e toda a sua equipe!&nbsp;&nbsp;<br />
        Venham passar esta tarde conosco!</p>
<p>
        &nbsp;</p>
<p>
        Vila Velha -Esp&iacute;rito Santo.</p>
<p>
        Data 16/10/2011 das 10 as 17 horas.</p>
<p>
        Hotel Quality.</p>
<p>
        Rua Antonio Gil Veloso, 856</p>
<p>
        Praia da Costa. Vila Velha.</p>
<p>
        Com a especial participa&ccedil;&atilde;o de Cesar Cezar,&nbsp;&nbsp;dando um SHOW de aula de nutri&ccedil;&atilde;o!</p>
<p>
        Pre&ccedil;o do convite R$ 15,00. Com o lanche em Nutra Meal, incluso.</p>
<p>
        Pre&ccedil;o promocional para pacotes com mais de 10 convites.</p>
<p>
        &Eacute; aceito o pagamento com b&ocirc;nus.</p>
<p>
        &nbsp;</p>
<p>
        Contato&nbsp;&nbsp;Clerisvaldo&nbsp;<span dir="ltr" style="clear:none !important;list-style-type:disc !important;" tabindex="-1">&nbsp;<span dir="ltr" skypeaction="skype_dropdown" style="clear:none !important;list-style-type:disc !important;" title="Call this phone number in Brazil with Skype: +552781784510">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="clear:none !important;list-style-type:disc !important;"><span style="clear:none !important;list-style-type:disc !important;">27-81784510</span></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp;</span></p>
<p>
        Esperamos voces!</p>

  ');

if User.count <= 0

  mx_btn=true
  mass=true
  lets_mail=true

  User.find_or_create_by_name({network_plan_id:17, status:1,person_type_id:1, person_nick:"apelido www", person_name:"meu nome completo www", account_type_id:2,cpf:"00985241519",name:"www",email1:"www@mylinuxserver1.info", email2:"www2@mylinuxserver1.info", admin:true, password:"vtr512", sponsor_id:1, address_attributes:{street_name:"Trv. 2 de maio", number:"29", complement:"Ao lado da Semed",neighborhood:"Centro", city_name:"Camaçari", state_name:"BA", country_id: 29, zip:"42800-530"}, matrix_button:mx_btn, comes_from_id:7, ignore_rules:true, network_setup:true, expire_date: Time.now+10.years},without_protection:true);
  #
  #User.find_or_create_by_name({network_plan_id:17, status:1,person_type_id:1, person_nick:"apelido www", person_name:"meu nome completo www", account_type_id:2,cpf:"00985241519",name:"luzia",email1:"luzia@mylinuxserver1.info", email2:"luzia2@mylinuxserver1.info", admin:true, password:"vtr512", sponsor_id:1,address_attributes:{street_name:"Trv. 2 de maio", number:"29", complement:"Ao lado da Semed",neighborhood:"Centro", city_name:"Camaçari", state_name:"BA", country_id: 29, zip:"42800-530"},matrix_button:mx_btn, mass:mass, comes_from_id:7},without_protection:true);
  #
  #User.find_or_create_by_name({network_plan_id:17, status:1,person_type_id:1, person_nick:"apelido www", person_name:"meu nome completo www", account_type_id:2,cpf:"00985241519",name:"joao",email1:"joao@mylinuxserver1.info", email2:"joao2@mylinuxserver1.info", admin:true, password:"vtr512", sponsor_id:1,address_attributes:{street_name:"Trv. 2 de maio", number:"29", complement:"Ao lado da Semed",neighborhood:"Centro", city_name:"Camaçari", state_name:"BA", country_id: 29, zip:"42800-530"},matrix_button:mx_btn, mass:mass, comes_from_id:7},without_protection:true);

  users=YAML::load_file("#{Rails.root.to_s}/db/users.yml")
  users.each {|x|

    person_type_id = (x["tipo"]=="pf") ? 1 : 2

    person_nick = x["nome"]
    name=MyTools.handle_user_names x["usuario"].to_s
    sponsor_name = x["usuario_indicador"].to_s=="nisher1" ? "www" : MyTools.handle_user_names(x["usuario_indicador"].to_s)
    password=x["senha"]
    sponsor=User.find_by_name(sponsor_name)

    cpf=x["cpf"].to_s
    cnpj=x["cnpj"].to_s

    email1=MyTools.handle_email1 x["email"], name
    email2=x["email2"] if x["email2"]!=x["email"]

    street_name=x["endereco"]
    number=x["numero"]
    complement=x["complemento"]
    neighborhood=x["bairro"]
    city_name=x["cidade"]
    state_name=x["estado"]
    country_id=29
    zip=x["cep"]

    phone = x["fone"]
    mobile = x["cel"]

    birth=Chronic.parse(x["datanasc"])
    gender_id = MyTools.handle_gender x["sexo"]

    user=User.find_or_create_by_name({network_plan_id:19, status:1,person_type_id:person_type_id, person_nick:person_nick, person_name:person_nick, company_nick: person_nick, company_name:person_nick,  account_type_id:2,cpf:cpf, cnpj:cnpj,name:name,email1:email1, email2:email2, password:password, sponsor_id:sponsor.id, address_attributes:{street_name:street_name, number:number, complement:complement,neighborhood:neighborhood, city_name:city_name, state_name:state_name, country_id: country_id, zip:zip}, matrix_button:mx_btn, comes_from_id:7, phone:phone, mobile:mobile, expire_date:Time.now+32.days, gender_id: gender_id,birth: birth,  network_setup: true, mass:true},without_protection:true);
    raise user.errors.inspect if user.errors.present?
  }
end
