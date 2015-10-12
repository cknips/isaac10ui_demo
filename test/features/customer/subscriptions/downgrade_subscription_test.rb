require "test_helper"

feature "Subscriptions test" do
  scenario "customer downgrades active subscription" do
    assert_equal(customers_subscription["status"], "ongoing")

    login_customer
    click_link("Buchungen")
    assert_equal(page.has_content?("monatlich"), true)

    # find downgradeable booking
    booking_links =
      page.all("a").select { |link| link.text == "Buchungsdetails" }
    booking_links[0].click
    if page.has_content?("Downgrade durchführen")
      click_link("Downgrade durchführen")
    else
      click_link("‹ zurück zur Buchungsübersicht")
      assert_equal(page.has_content?("monatlich"), true)
      booking_links =
        page.all("a").select { |link| link.text == "Buchungsdetails" }
      booking_links[1].click
      click_link("Downgrade durchführen")
    end

    # downgrade to free plan: no address data
    assert_equal(page.has_field?("Vorname"), false)
    click_button("Kostenpflichtig bestellen")

    # wait with API call
    sleep(20)

    # API call verifies customer has downgraded to new plan
    assert_equal(customers_subscription["status"], "future")

    # if test browser opens sent registration emails: go to first window
    page.within_window(windows.first) do
      assert_equal(page.has_content?("Vielen Dank für Ihre Buchung."), true)
      click_link("Buchungen")
      assert_equal(page.has_content?("zukünftig"), true)
    end
  end
end
