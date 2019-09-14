require 'rails_helper'

feature 'trainers linked to gym 'do
  scenario 'successfully' do
    gym = create(:gym)
    employeer = create(:employee, email: "email@espertofit.com.br", password: "123456",gym_id: gym.id )

    login_as employeer
    visit root_path
    click_on 'Cadastros'
    click_on "Cadastrar Professor" 
    fill_in "Nome", with: "Thiago"
    fill_in "CPF", with: "23"
    click_on "Cadastrar"

    expect(page).to have_content "Academias"
    expect(page).to have_content "Unidade: #{gym.id}"
  end

  scenario 'employee add more units ' do
    gym_1 = create(:gym)
    gym_2 = create(:gym)
    gym_3 = create(:gym)
    employeer = create(:employee, email: "email@espertofit.com.br", password: "123456", gym_id: gym_1.id , admin:true)
    trainer = create(:trainer, name:'Thi' )
    GymTrainer.create(trainer:trainer, gym:gym_1)

    login_as employeer
    visit root_path
    click_on 'Gerenciar'
    click_on 'Gerenciar Professores'
    click_on 'Thi'
    click_on 'Adicionar mais unidades'
    within("##{gym_2.id}") do
      click_on "Vincular"
    end
    click_on "Voltar"

    #expect(current_path).to eq(trainer)
    expect(page).to have_content('Unidade: 1')
    expect(page).to have_content('Unidade: 2')
    expect(page).not_to have_content('Unidade: 3')
  end

  scenario 'employee add more units ' do
    gym_1 = create(:gym)
    gym_2 = create(:gym)
    employeer = create(:employee, email: "email@espertofit.com.br", password: "123456", gym_id: gym_1.id , admin:true)
    trainer = create(:trainer, name: 'Thi')
    GymTrainer.create(trainer: trainer, gym: gym_1)

    login_as employeer
    visit root_path
    click_on 'Gerenciar'
    click_on 'Gerenciar Professores'
    click_on 'Thi'
    click_on 'Adicionar mais unidades'
    within("##{gym_1.id}") do
      click_on "Desvincular"
    end
    within("##{gym_2.id}") do
      click_on "Vincular"
    end
    click_on "Voltar"

    #expect(current_path).to eq(trainer)
    expect(page).not_to have_content('Unidade: 1')
    expect(page).to have_content('Unidade: 2')

  end
  scenario 'only admin can add trainer to more academys' do
    gym = create(:gym)
    employeer = create(:employee, email: "email@espertofit.com.br", password: "123456", gym:gym)
    trainer = create(:trainer, name:'Thi' )

    login_as(employeer)
    visit root_path
    click_on 'Gerenciar'
    click_on 'Gerenciar Professores'
    click_on 'Thi'

    expect(page).not_to have_link 'Adicionar mais unidades'
  end

  scenario 'only admin can add trainer to more academys' do
    gym  = create(:gym)
    employeer = create(:employee, email: "email@espertofit.com.br", password: "123456", gym:gym)
    trainer = create(:trainer, name:'Thi' )
    login_as(employeer)

    visit add_units_trainer_path(trainer)

    expect(current_path).to eq root_path

  end
end