class RegisterController < ApplicationController
  protect_from_forgery except: :create

  def index
    # set environment to development for not requesting lvh.me in test env
    gon.rails_env = Rails.env == "production" ? "production" : "development"
    gon.subdomain = Rails.application.config_for(:merchant)["subdomain"]
  end

  def create
    customer_number = params[:customer_number]
    customer_token  = params[:customer_api_token]
    email           = params[:email]
    password        = params[:password]
    customer        = Customer.new(email: email, password: password,
                                   customer_number: customer_number,
                                   customer_api_token: customer_token)
    if customer.save!
      flash.notice = t(".flash.registration_successful")
      redirect_to root_path
    else
      flash.alert = t(".flash.registration_failed")
      redirect_to root_path
    end
  end
end
