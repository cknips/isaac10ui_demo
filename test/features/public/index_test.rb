require "test_helper"

feature "Index page" do
  scenario "visit index page" do
    visit root_path
    assert_equal(page.has_content?("isaac10-UI Demo-Integration"), true)
  end
end
