namespace :scheduler do
  desc "Delete all registered customers"
  task delete_demo_customers: :environment do
    Customer.delete_all
    if Rails.env == "production"
      config = Rails.application.config_for(:customer)
      Customer.create(
        email: config["email"],
        password: config["password"],
        customer_number: config["customer_number"],
        customer_api_token: config["customer_api_token"])
    end
  end
end
