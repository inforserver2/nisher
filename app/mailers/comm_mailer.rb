#encoding: UTF-8
class CommMailer < ActionMailer::Base
  helper :application
  helper :comm
  helper :order
  def new_comm comm_id
    @comm = Comm.where(id:comm_id).includes(:user,:comm_type).first
    user = @comm.user
    headers={:to => user.email1, :subject => "#{CFG['domain']} - Nova comissão #{@comm.comm_type.name}"}
    headers[:bcc] = user.email2 if user.email2.present?
    mail(headers)
  end

  def new_transfer comm_id
    @comm = Comm.where(id:comm_id).includes(:user,:receiver).first
    user = @comm.user
    headers={:to => user.email1, :subject => "#{CFG['domain']} - Transferência de comissão"}
    bccs=[]
    bccs << user.email2 if user.email2.present?
    bccs << CFG['email-contact']
    headers[:bcc] = bccs
    mail(headers)
  end
  def new_credit comm_id
    @comm = Comm.where(id:comm_id).includes(:user,:sender).first
    user = @comm.user
    headers={:to => user.email1, :subject => "#{CFG['domain']} - Crédito de comissão"}
    headers[:bcc] = user.email2 if user.email2.present?
    mail(headers)
  end
  def new_order comm_id
    @comm = Comm.where(id:comm_id).includes(:user,:order).first
    user = @comm.user
    headers={:to => user.email1, :subject => "#{CFG['domain']} - Pagamento de fatura via saldo"}
    bccs=[]
    bccs << user.email2 if user.email2.present?
    bccs << CFG['email-contact']
    headers[:bcc] = bccs
    mail(headers)
  end
end
