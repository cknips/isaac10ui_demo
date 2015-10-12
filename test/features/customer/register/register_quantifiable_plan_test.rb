require "test_helper"

feature "Register test" do
  scenario "customer registers for not free plan with quantifiable addition" do
    visit root_path
    # avoid errors with covered elements
    page.current_window.resize_to(1024, 860)
    click_link "Produktseite"
    assert_equal(page.has_content?("Aktuelle Produkte"), true)
    assert_equal(page.current_path, "/products")

    plan_name =
      Rails.application.config_for(:merchant)["quantifiable_plan_name"]
    click_link(plan_name)

    # validations
    assert_equal(page.has_content?(plan_name), true)
    click_button("Kostenpflichtig bestellen")
    assert_equal(page.has_content?("muss ausgefüllt werden"), true)

    # scroll to top of page to avoid covered elements
    page.execute_script("window.scrollBy(0, -10000)")

    choose("nextBillingIntervalField-monthly")
    fill_in "firstNameField", with: "Test"
    fill_in "lastNameField", with: "Test"
    fill_in "streetField", with: "Teststr 12"

    # scroll to top of page to avoid covered elements
    # javascript on quantity field
    page.execute_script("window.scrollBy(0, -10000)")
    assert_equal(page.find("input[type='number']").disabled?, true)
    page.all("input.ember-checkbox")[1].click
    assert_equal(page.find("input[type='number']").disabled?, false)
    quantity_input_id =
      page.find("input[type='number']").native.attribute("id")
    fill_in(quantity_input_id, with: "3")
    fill_in "zipField", with: "12345"
    fill_in "cityField", with: "City"
    choose "paymentMethodField-invoice"
    click_button("Kostenpflichtig bestellen")

    # validations
    assert_equal(page.has_content?("Registrieren"), true)
    fill_in("emailField", with: "wrong")
    fill_in("passwordField", with: "123456")
    click_button("Kostenpflichtig bestellen")
    assert_equal(page.has_content?("ist nicht gültig"), true)

    customer_count_before = Customer.count
    new_email             = "new_email_25@example.com"
    fill_in("emailField", with: new_email)
    fill_in("passwordField", with: "123456")

    click_button("Kostenpflichtig bestellen")

    # new customer is created in demo app
    # wait for webhook & API call
    sleep(20)
    assert_equal(customer_count_before + 1, Customer.count)

    new_customer          = Customer.last
    # API call verifies customer has been created in isaac10 instance as well
    created_email         =
      customer_account_email(new_customer.customer_api_token,
                             new_customer.customer_number)
    new_subscription_plan = customers_plan(new_customer.customer_api_token,
                                           new_customer.customer_number)
    assert_equal(new_email, created_email)
    assert_equal(new_subscription_plan["plan_name"], plan_name)

    # if test browser opens sent emails
    page.within_window(windows.first) do
      assert_equal(page.has_content?("Vielen Dank für Ihre Buchung"), true)

      click_link("Zurück zur Händlerseite")
      assert_equal(page.has_content?("Demo"), true)
      assert_equal(page.current_path, "/register")
    end
  end
end
