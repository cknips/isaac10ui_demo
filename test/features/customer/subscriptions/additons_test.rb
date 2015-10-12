require "test_helper"

feature "Additions test" do
  scenario "customer adds/removes additions to plan" do
    additions_plan_name =
      Rails
      .application
      .config_for(:merchant)["quantifiable_plan_name"]

    login_customer
    click_link("Buchungen")
    assert_equal(page.has_content?("monatlich"), true)

    product_row =
      page.find("tr", text: additions_plan_name)
    within(product_row) do
      page.find("a").click
    end
    assert_equal(page.has_content?("Tarif wechseln"), true)

    click_link("Buchung bearbeiten")
    assert_equal(page.has_content?("Zusatzleistungen"), true)

    check("Hinzubuchen")
    click_button("Kostenpflichtig Bestellen")

    assert_equal(page.has_content?("Zusatzleistungen"), true)
    assert_equal(
      page.has_content?("Gebucht am #{I18n.l(Time.zone.today)}"), true
    )


    # API calls verifiy data has changed
    # check non-quantifiable addition is set
    standard_addition_name     = ""
    quantifiable_addition_name = ""
    customers_plan["additions"].each do |addition_hash|
      unless addition_hash["quantifiable"]
        standard_addition_name = addition_hash["name"]
      end
      if addition_hash["quantifiable"]
        quantifiable_addition_name = addition_hash["name"]
      end
    end
    customers_subscription["additions"].each do |addition_hash|
      if addition_hash["name"] == standard_addition_name
        assert_equal(addition_hash["quantity"], 1)
      end
      if addition_hash["name"] == quantifiable_addition_name
        assert_equal(addition_hash["quantity"], 0)
      end
    end


    # add quantifiable addon
    click_link("Buchung bearbeiten")
    assert_equal(page.has_content?("Zusatzleistungen"), true)
    quantity_input_id =
      page.find("input[type='number']").native.attribute("id")
    fill_in(quantity_input_id, with: "3")
    click_button("Kostenpflichtig Bestellen")

    assert_equal(page.has_content?("Tarif wechseln"), true)

    # check quantifiable addition is set
    customers_subscription["additions"].each do |addition_hash|
      if addition_hash["name"] == quantifiable_addition_name
        assert_equal(addition_hash["next_quantity"], 3)
      end
    end


    # remove addon again by setting quantity to '0'
    click_link("Buchung bearbeiten")
    assert_equal(page.has_content?("Zusatzleistungen"), true)
    quantity_input_id =
      page.find("input[type='number']").native.attribute("id")
    fill_in(quantity_input_id, with: "0")
    click_button("Kostenpflichtig Bestellen")

    assert_equal(page.has_content?("Tarif wechseln"), true)
    assert_equal(page.has_content?("gekündigt zum"), true)

    customers_subscription["additions"].each do |addition_hash|
      if addition_hash["name"] == quantifiable_addition_name
        assert_equal(addition_hash["next_quantity"], 0)
      end
    end


    # revert addon cacelation
    click_link("Buchung bearbeiten")
    assert_equal(page.has_content?("Zusatzleistungen"), true)
    quantity_input_id =
      page.find("input[type='number']").native.attribute("id")
    fill_in(quantity_input_id, with: "1")
    click_button("Kostenpflichtig Bestellen")

    customers_subscription["additions"].each do |addition_hash|
      if addition_hash["name"] == quantifiable_addition_name
        assert_equal(addition_hash["next_quantity"], 1)
      end
    end

    assert_equal(page.has_content?("Tarif wechseln"), true)
    assert_equal(page.has_content?("Änderung zum"), true)
    assert_equal(page.has_content?("Menge 1"), true)
    assert_equal(page.has_content?("gekündigt zum"), false)


    # cancel non-quantifiable addon
    click_link("Buchung bearbeiten")
    assert_equal(page.has_content?("Zusatzleistungen"), true)
    check("Kündigen")
    click_button("Kostenpflichtig Bestellen")

    customers_subscription["additions"].each do |addition_hash|
      if addition_hash["name"] == standard_addition_name
        assert_equal(addition_hash["next_quantity"], 0)
      end
    end

    assert_equal(page.has_content?("Tarif wechseln"), true)
    assert_equal(page.has_content?("gekündigt zum"), true)


    # revert cancelation of non-quantifiable addon
    click_link("Buchung bearbeiten")
    assert_equal(page.has_content?("Zusatzleistungen"), true)
    check("Kündigung aufheben")
    click_button("Kostenpflichtig Bestellen")

    assert_equal(page.has_content?("Tarif wechseln"), true)
    assert_equal(page.has_content?("gekündigt zum"), false)

    customers_subscription["additions"].each do |addition_hash|
      if addition_hash["name"] == standard_addition_name
        assert_equal(addition_hash["next_quantity"], 1)
      end
    end
  end
end
