namespace :auto do
  desc "cleans carts not owned in last 48hs"
  task :cart_clean, [:type_id] => :environment do |t, args|
    log=[]
    args.with_defaults type_id:0
    log << "-- Starting #{[desc, " at ", Time.now.to_s_br].join}"
    carts=Cart.where{(created_at < Time.now-2.days) & (order_id == nil)}
    count=0
    carts.each do |c|
      c.destroy
      log <<  "Temporary cart id #{c.id} has being deleted"
      count+=1
    end
    log << "Found: #{carts.size}"
    log << "reactivated via credit funds: #{count}"
    log << "-- End"
    puts log.join("\n")
    Job.create(name:"auto:cart_clean", type_id:args.type_id, log:log.join("\n"))
  end
end
