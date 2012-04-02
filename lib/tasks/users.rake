namespace :users do

  text0 = "try to make auto charges before inactive"
  desc text0
  task :auto_charge, [:type_id] => :environment do |t, args|
    log=[]
    args.with_defaults type_id:0
    log << "-- Starting #{[text0, " at ", Time.now.to_s_br].join}"
    users=User.includes(:comms).where(account_type_id:2, status:1, ignore_rules:false).where{expire_date < Time.now.to_date}
    count=0
    users.each do |u|
      credit=u.my_pending_credit
      cart=Cart.new_cart_seed u, Product.find(2)
      final_price=cart.final_price
      if credit >= final_price
        ActiveRecord::Base.transaction do
          order=u.orders.create(price:final_price, cart_id:cart.id, mailing:false, creating:true)
          order.update_attributes({closing:true, mailing:true, pay_via_credit:true},without_protection:true)
        end
        log << "User account id #{u.id} make new order and expand active expire_date via credit funds"
        count+=1
      else
        cart.destroy
      end
    end
    log << "Found: #{users.size}"
    log << "reactivated via credit funds: #{count}"
    log << "-- End"
    puts log.join("\n")
    Job.create(name:"users:auto_charge", type_id:args.type_id, log:log.join("\n"))
  end

  text1 = "inactive user accounts that completes 30 days without make any qualified order"
  desc text1
  task :inactive, [:type_id] => :environment do |t, args|
    log=[]
    args.with_defaults type_id:0
    log << "-- Starting #{[text1, " at ", Time.now.to_s_br].join}"
    users=User.where(account_type_id:2, status:1, ignore_rules:false).where{expire_date < Time.now.to_date}
    count=0
    users.each do |u|
      u.status=2
      if u.save validate:false
        log << "User account id #{u.id} inactivated"
        UserMailer.delay.inactive(u)
        count+=1
      end
    end
    log << "Found: #{users.size}"
    log << "Inactivated: #{count}"
    log << "-- End"
    puts log.join("\n")
    Job.create(name:"users:inactive", type_id:args.type_id, log:log.join("\n"))
  end

  text2 = "suspend users accounts that completes 60 days without make any qualified order"
  desc text2
  task :suspend, [:type_id] => :environment do |t, args|
    log=[]
    args.with_defaults type_id:0
    log << "-- Starting #{[text2, " at ", Time.now.to_s_br].join}"
    users=User.where(account_type_id:2, status:2, ignore_rules:false)
    count=0
    users.each do |u|
      if (u.expire_date+30.days).to_date < Time.now.to_date
        u.status=3
        if u.save validate:false
          log << "User account id #{u.id} suspended"
          UserMailer.delay.suspend(u)
          count+=1
        end
      end
    end
    log << "Found: #{users.size}"
    log << "Suspended: #{count}"
    log << "-- End"
    puts log.join("\n")
    Job.create(name:"users:suspend", type_id:args.type_id, log:log.join("\n"))
  end

  text3 = "send congratulations messages to the birthday users date"
  desc text3
  task :birthday, [:type_id] => :environment do |t, args|
    log=[]
    args.with_defaults type_id:0
    log << "-- Starting #{[text3, " at ", Time.now.to_s_br].join}"
    users=User.where(birthday:User.get_birthday_from_time(Time.now))
    count=0
    users.each do |u|
      log << "Birthday message sent to user id #{u.id}"
      UserMailer.delay.birthday(u)
      count+=1
    end
    log << "Found: #{users.size}"
    log << "Messages sent: #{count}"
    log << "-- End"
    puts log.join("\n")
    Job.create(name:"users:birthday", type_id:args.type_id, log:log.join("\n"))
  end

  text4 = "send reminder for pre-inactive users on last 7/3 before day"
  desc text4
  task :pre_inactive_reminder,[:type_id] => :environment do |t, args|
    args.with_defaults type_id:0
    log=[]
    log << "-- Starting #{[text4, " at ", Time.now.to_s_br].join}"
    users = User.where(account_type_id:2,status:1,expire_date:(Time.now+3.days).to_date..(Time.now+7.days).to_date).visible
    count=0
    users.each do |u|
      interval=User.get_date_interval u.expire_date,Time.now
      if User.reminder_interval_range? interval, User::PRE_INACTIVE_REMINDER_DATES
        UserMailer.delay.pre_inactive_reminder u
        log << "Reminder sent to user #{u.get_login}"
        count+=1
      end
    end
    log << "Sent: #{count} reminders"
    log << "-- End"

    puts log.join("\n")
    Job.create(name:"users:pre_inactive_reminder", type_id:args.type_id, log:log.join("\n"))
  end

  text5 = "send reminder for pre-suspend users on 15/20/25 after expire_date"
  desc text5
  task :pre_suspend_reminder,[:type_id] => :environment do |t, args|
    args.with_defaults type_id:0
    log=[]
    log << "-- Starting #{[text5, " at ", Time.now.to_s_br].join}"
    users = User.where(account_type_id:2,status:2,expire_date:(Time.now-25.days).to_date..(Time.now-15.days).to_date).visible
    count=0
    users.each do |u|
      interval=User.get_date_interval Time.now,u.expire_date
      if User.reminder_interval_range? interval, User::PRE_SUSPEND_REMINDER_DATES
        UserMailer.delay.pre_suspend_reminder u
        log << "Reminder sent to user #{u.get_login}"
        count+=1
      end
    end
    log << "Sent: #{count} reminders"
    log << "-- End"

    puts log.join("\n")
    Job.create(name:"users:pre_suspend_reminder", type_id:args.type_id, log:log.join("\n"))
  end
end
