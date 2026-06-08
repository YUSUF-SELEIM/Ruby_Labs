namespace :articles do
  desc "remove articles that have been reported 6 or more times"
  task remove_over_reported: :environment do
    deleted = Article.where("reports_count >= ?", 6).destroy_all
    puts "Removed #{deleted.count} over-reported article(s)"
  end
end