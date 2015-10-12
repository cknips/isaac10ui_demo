class Capybara::Rails::TestCase
  def login_customer
    visit root_path
    fill_in "session_email",    with: customers(:dummy_customer).email
    fill_in "session_password", with: "123456"
    click_button "Kundenlogin"
  end
end
