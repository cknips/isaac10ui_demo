class ProductsController < ApplicationController

  def index
    # set environment to development for not requesting lvh.me in test env
    gon.rails_env = Rails.env == "production" ? "production" : "development"
    gon.subdomain = Rails.application.config_for(:merchant)["subdomain"]
  end
end
