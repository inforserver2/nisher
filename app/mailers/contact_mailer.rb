class ContactMailer < ActionMailer::Base

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact.subject
  #
  def contact contact
    @contact =  ActiveSupport::JSON.decode(contact)
    @sponsor = User.find @contact["sponsor_id"]

    headers={:to => CFG['email-contact'], :subject => "#{CFG['domain']} - Contato"}
    headers[:reply_to] = @contact["email"]
    mail(headers)

  end
  def prospecto contact
    @contact =  ActiveSupport::JSON.decode(contact)
    @sponsor = User.find @contact["sponsor_id"]
    headers={:to => @sponsor.email1, :subject => "#{CFG['domain']} - Novo Contato Interessado"}
    bccs=[]
    bccs << @sponsor.email2 if @sponsor.email2.present?
    bccs << CFG['email-contact']
    headers[:bcc] = bccs
    headers[:reply_to] = @contact["email"]
    mail(headers)

  end
end
