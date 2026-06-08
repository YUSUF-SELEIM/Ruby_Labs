set :environment, :development   
set :output, "log/cron.log"      

every 1.minute do
  rake "articles:remove_over_reported"
end