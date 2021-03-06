require 'rails_helper'

  feature 'Owner create price_range by period' do
    scenario 'successfully' do
      owner = create(:user)
      login_as(owner)

      property_type = PropertyType.create(name: 'sitio')
      purpose = Purpose.create(name:'ferias')

      property = create(:property, title: 'Apartamento Top', property_type: property_type, owner_id: owner.id)

      PropertyPurpose.create(property: property, purpose: purpose)

      visit root_path

      click_on 'Apartamento Top'
      click_on 'Cadastrar valor por periodo'

      fill_in 'Data Inicial', with: '05/12/2017'
      fill_in 'Data Final', with: '05/01/2018'
      fill_in 'Valor da diaria', with: '150,00'

      click_on 'Enviar'

      expect(page).to have_css('h1', text: 'Preço cadastrado com sucesso')
      expect(page).to have_css('li', text: '05/12/2017')
      expect(page).to have_css('li', text: '05/01/2018')
      expect(page).to have_css('li', text: 'R$ 150,00')
    end

    scenario 'and missing some attribute' do
      owner = create(:user)
      login_as(owner)

      property_type = PropertyType.create(name: 'sitio')
      purpose = Purpose.create(name:'ferias')

      property = create(:property, title: 'Apartamento Top', property_type: property_type, owner_id: owner.id)

      PropertyPurpose.create(property: property, purpose: purpose)


      visit root_path
      click_on 'Apartamento Top'
      click_on 'Cadastrar valor por periodo'

      fill_in 'Data Inicial', with: ''
      fill_in 'Data Final', with: ''
      fill_in 'Valor da diaria', with: ''

      click_on 'Enviar'

      expect(page).to have_css('label', text: 'Houve um erro ao tentar cadastrar o preço por periodo')
    end

    scenario 'and start_date < today' do
      owner = create(:user)
      login_as(owner)

      property_type = PropertyType.create(name: 'sitio')
      purpose = Purpose.create(name:'ferias')

      property = create(:property, title: 'Apartamento Top', property_type: property_type, owner_id: owner.id)

      PropertyPurpose.create(property: property, purpose: purpose)

      visit root_path
      click_on 'Apartamento Top'
      click_on 'Cadastrar valor por periodo'

      fill_in 'Data Inicial', with: Date.today - 1
      fill_in 'Data Final', with: Date.today + 20
      fill_in 'Valor da diaria', with: '150,00'

      click_on 'Enviar'

      expect(page).to have_css('label', text: 'Data inicial deve ser maior ou igual a data de hoje')
    end

    scenario 'and start_date < today' do
      owner = create(:user)
      login_as(owner)

      property_type = PropertyType.create(name: 'sitio')
      purpose = Purpose.create(name:'ferias')

      property = create(:property, title: 'Apartamento Top', property_type: property_type, owner_id: owner.id)

      PropertyPurpose.create(property: property, purpose: purpose)

      visit root_path
      click_on 'Apartamento Top'
      click_on 'Cadastrar valor por periodo'

      fill_in 'Data Inicial', with: Date.today
      fill_in 'Data Final', with: Date.today - 20
      fill_in 'Valor da diaria', with: '150,00'

      click_on 'Enviar'

      expect(page).to have_css('label', text: 'Data final deve ser maior do que a data inicial')
    end

    scenario 'and period strikes another period' do
      owner = create(:user)
      login_as(owner)

      property_type = PropertyType.create(name: 'sitio')
      purpose = Purpose.create(name:'ferias')

      property = create(:property, title: 'Apartamento Top', property_type: property_type, owner_id: owner.id)

      PropertyPurpose.create(property: property, purpose: purpose)

      visit root_path
      click_on 'Apartamento Top'
      click_on 'Cadastrar valor por periodo'

      fill_in 'Data Inicial', with: Date.today
      fill_in 'Data Final', with: Date.today + 40
      fill_in 'Valor da diaria', with: '150,00'

      click_on 'Enviar'

      visit root_path
      click_on 'Apartamento Top'
      click_on 'Cadastrar valor por periodo'

      fill_in 'Data Inicial', with: Date.today + 30
      fill_in 'Data Final', with: Date.today + 70
      fill_in 'Valor da diaria', with: '150,00'

      click_on 'Enviar'

      expect(page).to have_css('label', text: 'Já existe um preço personalizado para esse periodo')
    end

  end
