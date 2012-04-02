#encoding: UTF-8
class PaymentMailer < ActionMailer::Base

  helper :application
  helper :comm
  helper :payments
  helper :order

  def new_payment payment_id
    @payment = Payment.where(id:payment_id).includes(:user).first
    user = @payment.user
    headers={:to => user.email1, :subject => "#{CFG['domain']} - Novo recebimento em conta bancária"}
    headers[:bcc] = user.email2 if user.email2.present?
    mail(headers)
  end

  def close_payment payment_id
    @payment = Payment.where(id:payment_id).includes(:user).first
    user = @payment.user
    headers={:to => user.email1, :subject => "#{CFG['domain']} - Recebimento em conta bancária concluído"}
    headers[:bcc] = user.email2 if user.email2.present?
    mail(headers)
  end



end
