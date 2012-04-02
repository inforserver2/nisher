#encoding: UTF-8
class UserMailer < ActionMailer::Base

  helper :application

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.send_my_password.subject
  #
  def send_my_password user
    @user = user
    headers={:to => user.email1, :subject => "#{CFG['domain']} - Senha"}
    headers[:bcc] = user.email2 if user.email2.present?
    mail(headers)
  end
  def welcome user
    @user = user
    headers={:to => user.email1, :subject => "#{CFG['domain']} - Bem vindo à Nisher"}
    headers[:bcc] = user.email2 if user.email2.present?
    mail(headers)
  end
  def sponsored user
    @user = user
    headers={:to => user.sponsor.email1, :subject => "#{CFG['domain']} - Novo usuário cadastrado em seu site"}
    headers[:bcc] = user.sponsor.email2 if user.sponsor.email2.present?
    mail(headers)
  end
  def inactive user
    @user = user
    headers={:to => user.email1, :subject => "#{CFG['domain']} - Sua conta foi inativada"}
    headers[:bcc] = user.email2 if user.email2.present?
    mail(headers)
  end
  def suspend user
    @user = user
    headers={:to => user.email1, :subject => "#{CFG['domain']} - Sua conta foi suspensa"}
    headers[:bcc] = user.email2 if user.email2.present?
    mail(headers)
  end
  def birthday user
    @user = user
    headers={:to => user.email1, :subject => "#{CFG['domain']} - Feliz aniversário"}
    headers[:bcc] = user.email2 if user.email2.present?
    mail(headers)
  end
  def pre_inactive_reminder user
    @user = user
    interval=User.get_date_interval user.expire_date, Time.now
    total = User::PRE_INACTIVE_REMINDER_DATES.size
    headers={:to => user.email1, :subject => "#{CFG['domain']} - Lembrete: estamos aguardando seu Pedido adicional (#{User.pre_inactve_reminder_count interval}/#{total})"}
    headers[:bcc] = user.email2 if user.email2.present?
    mail(headers)
  end
  def pre_suspend_reminder user
    @user = user
    interval=User.get_date_interval Time.now,user.expire_date
    total = User::PRE_SUSPEND_REMINDER_DATES.size
    headers={:to => user.email1, :subject => "#{CFG['domain']} - Lembrete: Reative sua Conta Urgente (#{User.pre_suspend_reminder_count interval}/#{total})"}
    headers[:bcc] = user.email2 if user.email2.present?
    mail(headers)
  end
end
