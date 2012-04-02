namespace :orders do

  text1 = "send reminder for pending orders at the 3/10/15 day"
  desc text1
  task :reminder,[:type_id] => :environment do |t, args|
    args.with_defaults type_id:0
    log=[]
    log << "-- Starting #{[text1, " at ", Time.now.to_s_br].join}"
    orders = Order.where(status:0,created_at:((Time.now-15.days).to_date)..(Time.now-3.days).to_date).includes(:user)
    count=0
    orders.each do |o|
      interval=Order.get_date_interval Time.now, o.created_at
      if Order.reminder_interval_range? interval
        OrderMailer.delay.reminder o if o.user.visible?
        log << "Reminder of order_id #{o.id} sent to user #{o.user.get_login}"
        count+=1
      end
    end
    log << "Sent: #{count} reminders"
    log << "-- End"

    puts log.join("\n")
    Job.create(name:"orders:reminder", type_id:args.type_id, log:log.join("\n"))
  end
end
