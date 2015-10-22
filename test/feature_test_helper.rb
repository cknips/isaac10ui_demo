class Capybara::Rails::TestCase
  def login_customer
    visit root_path
    email    = Rails.application.config_for(:customer)["email"]
    password = Rails.application.config_for(:customer)["password"]
    fill_in "session_email",    with: email
    fill_in "session_password", with: password
    click_button "Kundenlogin"
  end
end
