require "test_helper"

feature "Subscriptions test" do
  scenario "customer changes billing interval of active subscription" do
    login_customer
    click_link("Buchungen")
    assert_equal(page.has_content?("monatlich"), true)

    product_row =
      page.find("tr", text: customers_subscription_name)
    within(product_row) do
      page.find("a").click
    end
    assert_equal(page.has_content?("Buchung"), true)

    click_link("Buchung bearbeiten")
    assert_equal(page.has_content?("Buchung bearbeiten"), true)

    click_link("‹ zurück zur Buchung")
    assert_equal(page.has_content?("Buchung bearbeiten"), true)

    click_link("Buchung bearbeiten")
    assert_equal(page.has_content?("Buchung bearbeiten"), true)
    # verify javascript on page changes prices
    choose("jährlich")
    assert_equal(page.has_content?("pro Jahr"), true)
    choose("monatlich")
    assert_equal(page.has_content?("pro Monat"), true)

    choose("jährlich")
    click_button("Kostenpflichtig Bestellen")

    assert_equal(page.has_content?("zukünftiger Preis"), true)
    # TODO: Anzeigefehler
    skip("TODO: Test failing ATM")
    assert_equal(page.has_content?("pro Jahr"), true)

    # API call verifies data has changed
    assert_equal(customers_subscription["next_billing_interval"], "yearly")

    click_link("‹ zurück zur Buchungsübersicht")
    # current billing inverval has not changed
    assert_equal(page.has_content?("monatlich"), true)
  end
end
