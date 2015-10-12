namespace :scheduler do
  desc "Delete all registered customers"
  task delete_demo_customers: :environment do
    Customer.delete_all
  end
end
