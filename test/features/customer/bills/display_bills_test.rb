require "test_helper"

feature "Customer account" do
  scenario "dispay bills" do
    login_customer
    click_link("Rechnungen")

    assert_equal(page.has_content?("Rechnungsnummer"), true)
    assert_equal(page.has_content?("Keine Rechnungen hinterlegt"), false)
    assert_equal(page.current_path, "/customer")


    customer_bills.each do |key, value|
      next if key == "url"
      assert_equal(page.has_content?(value), true)
    end
  end
end
