class SessionsController < ApplicationController

  def create
    customer = Customer.find_by(email: params[:session][:email].downcase)
    if customer && customer.authenticate(params[:session][:password])
      log_in(customer)
      flash.notice = t(".flash.login_successful")
      redirect_to root_path
    else
      flash.alert = t(".flash.login_not_successful")
      redirect_to root_path
    end
  end

  def destroy
    log_out if logged_in?
    flash.notice = t(".flash.logout_successful")
    redirect_to root_path
  end
end
