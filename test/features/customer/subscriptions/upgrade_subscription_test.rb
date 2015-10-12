require "test_helper"

feature "Subscriptions test" do
  scenario "customer upgrades active subscription" do
    # customer has just downgraded
    assert_equal(customers_subscription["status"], "future")

    login_customer
    click_link("Buchungen")
    assert_equal(page.has_content?("monatlich"), true)

    # find upgradeable booking
    booking_links =
      page.all("a").select { |link| link.text == "Buchungsdetails" }
    booking_links[0].click
    if page.has_content?("Upgrade durchführen")
      click_link("Upgrade durchführen")
    else
      click_link("‹ zurück zur Buchungsübersicht")
      assert_equal(page.has_content?("monatlich"), true)
      booking_links =
        page.all("a").select { |link| link.text == "Buchungsdetails" }
      booking_links[1].click
      click_link("Upgrade durchführen")
    end

    # no address data, billing data already present
    assert_equal(page.has_field?("Vorname"), false)
    click_button("Kostenpflichtig bestellen")
    # assert_equal(page.has_content?("muss ausgefüllt werden"), true)

    # wait with API call
    sleep(20)

    # API call verifies customer has upgraded to new plan
    assert_equal(customers_subscription["status"], "ongoing")

    # if test browser opens sent registration emails: go to first window
    page.within_window(windows.first) do
      assert_equal(page.has_content?("Vielen Dank für Ihre Buchung."), true)
      click_link("Buchungen")
      assert_equal(page.has_content?("abgelaufen"), true)
    end
  end
end
