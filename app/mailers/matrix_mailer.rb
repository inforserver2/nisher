#encoding: UTF-8
class MatrixMailer < ActionMailer::Base
  helper :application

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.matrix_mailer.meta.subject
  #
  def meta matrix, level
    @matrix = matrix
    @user = matrix.user
    @level = level
    headers={:to => @user.email1, :subject => "#{CFG['domain']} - Matriz Nível #{level} Concluído"}
    bccs=[]
    bccs << @user.email2 if @user.email2.present?
    bccs << CFG['email-contact']
    headers[:bcc] = bccs
    mail(headers)
  end
end
