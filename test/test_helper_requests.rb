class ActiveSupport::TestCase
  def product_names
    product_names = []
    current_products["products"].each do |k, v|
      product_names << k.keys
    end
    product_names.flatten!
  end

  def plan_names
    plan_names = []
    plan_array.each do |hsh|
      plan_names << hsh.keys
    end
    plan_names.flatten!
  end

  def customer_account_email(customer_token=nil, customer_number=nil)
    customer_data_hash(customer_token, customer_number)["account_data"]["email"]
  end

  def customer_account_billing_data(customer_token=nil, customer_number=nil)
    billing_data_array =
      customer_data_hash(customer_token, customer_number)["billing_data"].values
    billing_data_array.delete("male")
    billing_data_array.delete("female")
    billing_data_array.delete("DE")
    billing_data_array.compact
  end

  def customer_account_payment_data(customer_token=nil, customer_number=nil)
    customer_data_hash(customer_token, customer_number)["payment_data"].values
  end

  def customer_bills
    bill_data = {}
    customer_bills_array.each do |bill_hash|
      bill_data["number"] = bill_hash["bill_number"]
      bill_data["date"]   = I18n.l(Date.parse(bill_hash["billed_at"]))
      bill_data["url"]    = bill_hash["url"]
    end
    bill_data
  end

  def customer_subscriptions(customer_token=nil, customer_number=nil)
    subscriptions_array = []
    customer_subscriptions_array(customer_token, customer_number)
      .each do |subs_hash|
        subscriptions_array << subs_hash["product_name"]
        subscriptions_array << subs_hash["plan_name"]
        subscriptions_array << I18n.l(Date.parse(subs_hash["begins_at"]))
        subscriptions_array << I18n.l(Date.parse(subs_hash["term_ends_at"]))
    end
    subscriptions_array
  end

  def customers_subscription_name(customer_token=nil, customer_number=nil)
    customer_subscriptions_array(customer_token, customer_number)
      .first["plan_name"]
  end

  def customers_subscription(customer_token=nil, customer_number=nil)
    id =
      customer_subscriptions_array(customer_token, customer_number).first["id"]
    unless customer_token
      customer_token  = customers(:dummy_customer).customer_api_token
    end
    unless customer_number
      customer_number = customers(:dummy_customer).customer_number
    end
    url               =
      "/api/v1/customer/#{customer_number}/subscriptions/#{id}/edit"
    subscription_hash =
      connection.get do |request|
        request.url url
        request.headers["Authorization"] = "Token token=#{customer_token}"
      end
    ActiveSupport::JSON.decode(subscription_hash.body)["subscription"]
  end

  def customers_plan(customer_token=nil, customer_number=nil)
    id =
      customer_subscriptions_array(customer_token, customer_number).first["id"]
    unless customer_token
      customer_token  = customers(:dummy_customer).customer_api_token
    end
    unless customer_number
      customer_number = customers(:dummy_customer).customer_number
    end
    url               =
      "/api/v1/customer/#{customer_number}/subscriptions/#{id}/edit"
    subscription_hash =
      connection.get do |request|
        request.url url
        request.headers["Authorization"] = "Token token=#{customer_token}"
      end
    ActiveSupport::JSON.decode(subscription_hash.body)["plan"]
  end


  private
  def connection
    url = Rails.application.config_for(:merchant)["api_url"]
    @_connection ||= Faraday.new(:url => url) do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end
  end

  def customer_data_hash(customer_token=nil, customer_number=nil)
    unless customer_token
      customer_token  = customers(:dummy_customer).customer_api_token
    end
    unless customer_number
      customer_number = customers(:dummy_customer).customer_number
    end
    url               = "/api/v1/customer/#{customer_number}/account"
    customer_hash     =
      connection.get do |request|
        request.url url
        request.headers["Authorization"] = "Token token=#{customer_token}"
      end
    ActiveSupport::JSON.decode(customer_hash.body)["account"]
  end

  def current_products
    @_products_hash ||=
      ActiveSupport::JSON.decode(connection.get("/api/v1/products").body)
  end

  def plan_array
    array = []
    current_products["products"].each do |prod_h|
      product_names.each do |name|
        if prod_h[name]
          prod_h[name].each do |plan_h|
            array << plan_h
          end
        end
      end
    end
    array.flatten!.delete("plans")
    array
  end

  def customer_bills_array
    customer_token     = customers(:dummy_customer).customer_api_token
    customer_number    = customers(:dummy_customer).customer_number
    url                = "/api/v1/customer/#{customer_number}/bills"
    @_bills_hash  ||=
      connection.get do |request|
        request.url url
        request.headers["Authorization"] = "Token token=#{customer_token}"
      end
    ActiveSupport::JSON.decode(@_bills_hash.body)["bills"].flatten
  end

  def customer_subscriptions_array(customer_token=nil, customer_number=nil)
    unless customer_token
      customer_token   = customers(:dummy_customer).customer_api_token
    end
    unless customer_number
      customer_number  = customers(:dummy_customer).customer_number
    end
    url                = "/api/v1/customer/#{customer_number}/subscriptions"
    subscriptions_hash =
      connection.get do |request|
        request.url url
        request.headers["Authorization"] = "Token token=#{customer_token}"
      end
    ActiveSupport::JSON.decode(subscriptions_hash.body)["subscriptions"]
  end
end
