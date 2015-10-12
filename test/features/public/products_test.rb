require "test_helper"

feature "Products test" do
  scenario "products page displays products and plans" do
    visit root_path
    click_link "Produktseite"

    assert_equal(page.has_content?("Aktuelle Produkte"), true)
    assert_equal(page.current_path, "/products")

    product_names.each do |product_name|
      assert_equal(page.has_content?(product_name), true)
    end

    plan_names.each do |plan_name|
      assert_equal(page.has_content?(plan_name), true)
    end
  end
end
