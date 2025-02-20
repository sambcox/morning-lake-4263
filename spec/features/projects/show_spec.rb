require 'rails_helper'

RSpec.describe 'Projects Show View', type: :feature do
  describe 'Project Show' do
    before :each do
      @recycled_material_challenge = Challenge.create(theme: "Recycled Material", project_budget: 1000)
      @furniture_challenge = Challenge.create(theme: "Apartment Furnishings", project_budget: 1000)

      @news_chic = @recycled_material_challenge.projects.create(name: "News Chic", material: "Newspaper")
      @boardfit = @recycled_material_challenge.projects.create(name: "Boardfit", material: "Cardboard Boxes")

      @upholstery_tux = @furniture_challenge.projects.create(name: "Upholstery Tuxedo", material: "Couch")
      @lit_fit = @furniture_challenge.projects.create(name: "Litfit", material: "Lamp")

      @jay = Contestant.create(name: "Jay McCarroll", age: 40, hometown: "LA", years_of_experience: 13)
      @gretchen = Contestant.create(name: "Gretchen Jones", age: 36, hometown: "NYC", years_of_experience: 12)
      @kentaro = Contestant.create(name: "Kentaro Kameyama", age: 30, hometown: "Boston", years_of_experience: 8)
      @erin = Contestant.create(name: "Erin Robertson", age: 44, hometown: "Denver", years_of_experience: 15)


      ContestantProject.create(contestant_id: @jay.id, project_id: @news_chic.id)
      ContestantProject.create(contestant_id: @gretchen.id, project_id: @news_chic.id)
      ContestantProject.create(contestant_id: @gretchen.id, project_id: @upholstery_tux.id)
      ContestantProject.create(contestant_id: @kentaro.id, project_id: @upholstery_tux.id)
      ContestantProject.create(contestant_id: @kentaro.id, project_id: @boardfit.id)
      ContestantProject.create(contestant_id: @erin.id, project_id: @boardfit.id)
    end
    it 'displays the project information' do

      visit "/projects/#{@news_chic.id}"

      expect(page).to have_content('News Chic')
      expect(page).to have_content('Newspaper')
      expect(page).to have_content('Recycled Material')
    end

    it 'displays the number of contestants on the project' do
      visit "/projects/#{@news_chic.id}"

      expect(page).to have_content('Contestants: 2')
    end

    it 'displays the average experience of the contestants' do
      visit "/projects/#{@news_chic.id}"

      expect(page).to have_content('Average Contestant Experience: 12.5 years')
    end

    it 'allows you to add a contestant to a project' do
      visit "/projects/#{@news_chic.id}"


      fill_in('add_contestant', with: @kentaro.id)
      click_button 'Add Contestant to Project'

      expect(current_path).to eq("/projects/#{@news_chic.id}")
      expect(page).to have_content('Contestants: 3')

      visit '/contestants'

      expect(page).to have_content('News Chic').thrice
    end
  end
end