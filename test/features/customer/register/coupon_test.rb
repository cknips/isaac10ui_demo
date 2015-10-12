require "test_helper"

feature "Coupon test" do
  scenario "customer checks coupon code" do
    visit root_path
    click_link "Produktseite"
    assert_equal(page.has_content?("Aktuelle Produkte"), true)
    assert_equal(page.current_path, "/products")

    plan_name   =
      Rails.application.config_for(:merchant)["quantifiable_plan_name"]
    coupon_code = Rails.application.config_for(:merchant)["coupon_code"]

    click_link(plan_name)

    fill_in("couponCodeField", with: "wrong")
    click_button("Code überprüfen")
    assert_equal(
      page.has_content?("Der Gutschein-Code ist nicht gültig."), true
    )

    fill_in("couponCodeField", with: coupon_code)
    assert_equal(
      page.has_content?("Der Gutschein-Code ist nicht gültig."), false
    )
    click_button("Code überprüfen")

    assert_equal(
      page.has_content?("Der Gutschein-Code ist nicht gültig."), false
    )
    assert_equal(page.has_css?("span.glyphicon-ok"), true)
  end
end
