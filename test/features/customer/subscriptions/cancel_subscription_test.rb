require "test_helper"

feature "Subscriptions test" do
  scenario "customer cancels active subscription" do
    assert_equal(customers_subscription["status"], "ongoing")

    login_customer
    click_link("Buchungen")
    assert_equal(page.has_content?("monatlich"), true)

    product_row =
      page.find("tr", text: customers_subscription_name)
    within(product_row) do
      page.find("a").click
    end
    assert_equal(page.has_content?("Buchung"), true)

    click_link("Buchung kündigen")
    assert_equal(page.has_content?("Sind Sie sicher"), true)
    click_link("‹ zurück zur Buchung")
    assert_equal(page.has_content?("Buchung"), true)


    click_link("Buchung kündigen")
    assert_equal(page.has_content?("Sind Sie sicher"), true)

    click_button("Kündigung bestätigen")
    assert_equal(page.has_content?("in Kündigung"), true)
    click_link("‹ zurück zur Buchungsübersicht")
    assert_equal(page.has_content?("in Kündigung"), true)

    # wait with API call
    sleep(20)

    # API call verifies data has changed
    assert_equal(customers_subscription["status"], "expired")
  end

  scenario "customer reverts cancelation of active subscription" do
    skip("subscription cancelation reversal not implemented yet")
  end
end
