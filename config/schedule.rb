set :environment, :development   
set :output, "log/cron.log"      

every 5.minutes do
  rake "articles:remove_over_reported"
end