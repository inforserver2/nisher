# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
env 'PATH', ENV['PATH']
set :output, "#{path}/log/cron.log"
job_type :script, "'#{path}/script/:task' :output"
#
#every 15.minutes do
#  command "rm '#{path}/tmp/cache/foo.txt'"
#  script "generate_report"
#end
#
#every :sunday, at: "4:28 AM" do
#  runner "Cart.clear_abandoned"
#end
#
#every :reboot do
#  rake "ts:start"
#end
#
#
every :reboot do
  rake "system:tellboot"
  command "#{path}/script/delayed_job start"
end

every 1.day, at:"11pm" do
 command "astrails-safe #{path}/config/astrails_safe.rb"
end

every 1.day, at:"11:15 pm" do
  rake "auto:cart_clean"
end

every 1.day, at:"11:30 pm" do
  rake "carrier:cache_clean"
end

every 1.month, :at => "start of the month at 1am" do
  rake "payment:generator"
end

every 1.day, at:"1:30 am" do
  rake "users:auto_charge"
end

every 1.day, at:"2 am" do
  rake "users:inactive"
end

every 1.day, at:"2:30 am" do
  rake "users:suspend"
end

every 1.day, at:"3am" do
  rake "users:birthday"
end

every 1.day, at:"3:30 am" do
  rake "orders:reminder"
end

every 1.day, at:"4am" do
  rake "users:pre_inactive_reminder"
end

every 1.day, at:"4:30 am" do
  rake "users:pre_suspend_reminder"
end


# whenever -w -s environment=development
# whenever -w -s environment=production

