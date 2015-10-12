require "test_helper"

feature "Subscriptions test" do
  scenario "subscriptions page displays subscriptions" do
    login_customer
    click_link("Buchungen")
    assert_equal(page.has_content?("monatlich"), true)
    assert_equal(page.current_path, "/customer")

    customer_subscriptions.each do |subs_data|
      assert_equal(page.has_content?(subs_data), true)
    end
  end
end
