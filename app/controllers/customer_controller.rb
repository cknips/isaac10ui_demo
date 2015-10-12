class CustomerController < ApplicationController

  def index
    # set environment to development for not requesting lvh.me in test env
    if Rails.env == "production"
      gon.rails_env     = "production"
    else
      gon.rails_env     = "development"
    end
    gon.subdomain       = Rails.application.config_for(:merchant)["subdomain"]
    gon.customer_number = current_user.customer_number
    gon.customer_token  = current_user.customer_api_token
  end
end
