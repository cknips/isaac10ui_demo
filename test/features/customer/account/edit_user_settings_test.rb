require "test_helper"

feature "Customer account" do
  scenario "edit user settings" do
    login_customer
    click_link("Accountdaten")
    click_link("E-Mail-Adresse ändern")
    assert_equal(page.has_content?("Account"), true)

    fill_in "emailField", with: "foo"
    click_button "Speichern"
    assert_equal(page.current_path, "/customer")
    assert_equal(page.has_content?("ist nicht gültig"), true)

    new_email = "new.email@example.com"
    fill_in "emailField", with: new_email
    click_button "Speichern"
    assert_equal(page.current_path, "/customer")

    # API call verifies e-mail actually changed
    assert_equal(customer_account_email, new_email)
    assert_equal(page.has_content?(new_email), true)
  end
end
