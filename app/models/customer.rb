# == Schema Information
#
# Table name: customers
#
#  id                 :integer          not null, primary key
#  email              :string
#  password_digest    :string
#  auth_token         :string
#  customer_number    :string
#  customer_api_token :string
#  created_at         :datetime
#  updated_at         :datetime
#
# Indexes
#
#  index_customers_on_auth_token  (auth_token) UNIQUE
#  index_customers_on_email       (email) UNIQUE
#

class Customer < ActiveRecord::Base
  has_secure_password

end
