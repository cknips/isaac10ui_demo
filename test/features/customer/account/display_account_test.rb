require "test_helper"

feature "Customer account" do
  scenario "display account settings" do
    login_customer
    click_link("Accountdaten")

    assert_equal(page.has_content?("Account"), true)
    assert_equal(page.has_content?("Account-Daten"), true)
    assert_equal(page.has_content?(customer_account_email), true)
    assert_equal(page.current_path, "/customer")

    assert_equal(page.has_content?("Rechnungsadresse"), true)
    customer_account_billing_data.each do |datum|
      assert_equal(page.has_content?(datum), true)
    end

    assert_equal(page.has_content?("Zahlungsmethode"), true)
    # check billing data with api
    case customer_account_payment_data[0]
    when "invoice"
      assert_equal(page.has_content?("auf Rechnung"), true)
    when "elv_dtaus"
      assert_equal(page.has_content?("Elektronische Lastschrift"), true)
    end
  end
end
