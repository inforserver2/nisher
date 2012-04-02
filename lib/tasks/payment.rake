namespace :payment do

  text1 = "gen payments for qualified users"
  desc text1
  task :generator,[:type_id] => :environment do |t, args|
    args.with_defaults type_id:0
    log=[]
    log << "-- Starting #{[text1, " at ", Time.now.to_s_br].join}"
    users_ids = Comm.select("sum(value) as value, user_id").group("user_id").having("sum(value) > ?", 10).free.map(&:user_id)
    users = User.where(id:users_ids).includes(:sponsored,:comms)
    count=0
    users.each do |user|
      total=user.comms.free.sum(:value)
      payment=user.payments.create(value:total) if user.sponsored.where(status:1).count >= 3
      log << "Payment id #{payment.id} has being created for the user #{user.get_login}" if payment
      count+=1 if payment
    end
    log << "Created: #{count} payments"
    log << "-- End"

    puts log.join("\n")
    Job.create(name:"payment:generator", type_id:args.type_id, log:log.join("\n"))
  end
end
