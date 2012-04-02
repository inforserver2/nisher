class OrderMailer < ActionMailer::Base
  helper :order
  helper :application
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.new_order.subject
  #
  def new_order order
    @order=order
    user = order.user
    headers={:to => user.email1, :subject => "#{CFG['domain']} - Novo pedido"}
    headers[:bcc] = user.email2 if user.email2.present?
    mail(headers)
  end

  def close_order order
    @order=order
    user = order.user
    headers={:to => user.email1, :subject => "#{CFG['domain']} - Seu pagamento foi confirmado"}
    headers[:bcc] = user.email2 if user.email2.present?
    mail(headers)
  end

  def reminder order
    @order=order
    user = order.user
    interval=Order.get_date_interval Time.now, order.created_at
    total = Order::REMINDER_DATES.size
    headers={:to => user.email1, :subject => "#{CFG['domain']} - Lembrete Pedido em aberto (#{Order.reminder_count interval}/#{total})"}
    headers[:bcc] = user.email2 if user.email2.present?
    mail(headers)
  end


end
