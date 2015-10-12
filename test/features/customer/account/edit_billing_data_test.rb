require "test_helper"

feature "Customer account" do
  scenario "edit billing data" do
    login_customer
    click_link("Accountdaten")
    click_link("Rechnungsadresse ändern")

    fill_in "firstNameField", with: ""
    click_button "Speichern"
    assert_equal(page.current_path, "/customer")
    assert_equal(page.has_content?("muss ausgefüllt werden"), true)

    new_data = %w[Dr. First Name Company2 Street 54321 City]
    fill_in "titleField",     with: new_data[0]
    fill_in "firstNameField", with: new_data[1]
    fill_in "lastNameField",  with: new_data[2]
    fill_in "companyField",   with: new_data[3]
    fill_in "streetField",    with: new_data[4]
    fill_in "zipField",       with: new_data[5]
    fill_in "cityField",      with: new_data[6]

    click_button "Speichern"
    new_data.each do |datum|
      assert_equal(page.has_content?(datum), true)
    end

    # API call verifies billing data has changed
    assert_equal(customer_account_billing_data, new_data)
  end
end
