require "test_helper"

feature "Customer account" do
  scenario "edit payment data" do
    login_customer
    click_link("Accountdaten")
    click_link("Zahlungsmethode ändern")

    click_button "Speichern"
    assert_equal(page.has_content?("muss ausgefüllt werden"), true)

    choose "Elektronische Lastschrift"
    new_data = ["elv_dtaus", "New Name", "DE21500500009876543210"]
    fill_in "addrNameField", with: new_data[1]
    fill_in "bankIbanField", with: new_data[2]

    click_button "Speichern"
    new_data.last(2).each do |datum|
      assert_equal(page.has_content?(datum), true)
    end

    assert_equal(customer_account_payment_data, new_data)
  end
end
