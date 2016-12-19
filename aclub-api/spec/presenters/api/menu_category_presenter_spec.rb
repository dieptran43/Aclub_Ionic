require 'rails_helper'

module Api
  RSpec.describe MenuCategoryPresenter do
    let(:menu_category) { create(:menu_category) }
    let(:subject) { JSON.parse(MenuCategoryPresenter.new(menu_category).to_json) }
    let(:expected_result) { 
      HashWithIndifferentAccess.new({
        id: menu_category.id,
        name: menu_category.name
      })
    }

    describe '#as_json' do
      it 'should build json presenter for menu_category' do
        expect(subject).to eq expected_result
      end
    end
  end
end
