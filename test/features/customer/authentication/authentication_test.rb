require "test_helper"

feature "Customer authentication" do
  scenario "login and logout" do
    visit root_path

    fill_in "session_email",    with: customers(:dummy_customer).email
    fill_in "session_password", with: ""
    click_button "Kundenlogin"
    assert_equal(page.has_content?("Login nicht erfolgreich"), true)
    assert_equal(page.current_path, "/")

    fill_in "session_email",    with: customers(:dummy_customer).email
    fill_in "session_password", with: "foobar"
    click_button "Kundenlogin"
    assert_equal(page.has_content?("Login nicht erfolgreich"), true)
    assert_equal(page.current_path, "/")

    fill_in "session_email",    with: customers(:dummy_customer).email
    fill_in "session_password", with: "123456"
    click_button "Kundenlogin"
    assert_equal(page.has_content?("Login erfolgreich"), true)
    assert_equal(page.current_path, "/")
    assert_equal(page.has_content?("Accountdaten"), true)
    assert_equal(page.has_content?("Buchungen"), true)
    assert_equal(page.has_content?("Rechnungen"), true)

    click_button "Logout"
    assert_equal(page.has_content?("Logout erfolgreich"), true)
    assert_equal(page.current_path, "/")
  end
end
