require "test_helper"

feature "Customer account" do
  scenario "download bills" do
    login_customer
    click_link("Rechnungen")

    assert_equal(page.has_content?("Rechnungsnummer"), true)
    new_window = window_opened_by { page.first(".glyphicon").click }
    within_window new_window do
      # we are in the browser's pdf viewer
      assert_equal(current_url.include?(".pdf"), true)
    end
  end
end
