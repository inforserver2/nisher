namespace :system do

  text1 = "records to jober when the server has been restarted"
  desc text1
  task :tellboot, [:type_id] => :environment do |t, args|
    log=[]
    args.with_defaults type_id:0
    log << "-- Starting #{[text1, " at ", Time.now.to_s_br].join}"
    log << "\tServer has been rebooted."
    log << "-- End"
    puts log.join("\n")
    Job.create(name:"system:tellboot", type_id:args.type_id, log:log.join("\n"))
  end
end
