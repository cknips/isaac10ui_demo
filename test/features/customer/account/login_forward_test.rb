require "test_helper"

feature "Customer account" do
  scenario "request with api_token does not trigger friendly forwarding" do

    visit("/external_links")
    click_link("Customer Dashboard")
    assert_equal(page.has_content?("Account"), true)

    visit("/external_links")
    click_button("Customer Dashboard")
    assert_equal(page.has_content?("Account"), true)

    visit("/external_links")
    click_button("Customer Account")
    assert_equal(page.has_content?("Account"), true)
    assert_equal(page.has_content?("Account-Daten"), true)
  end
end
