namespace :carrier do

  text1 = "cleaning cached images uploaded in last 24hs"
  desc text1
  task :cache_clean, [:type_id] => :environment do |t, args|
    log=[]
    args.with_defaults type_id:0
    log << "-- Starting #{[text1, " at ", Time.now.to_s_br].join}"
    info = CarrierWave.clean_cached_files!
    log << info.to_s
    log << "-- End"
    puts log.join("\n")
    Job.create(name:"carrier:cache_clean", type_id:args.type_id, log:log.join("\n"))
  end
end
