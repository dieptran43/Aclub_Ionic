require 'rails_helper'

module Api
  RSpec.describe MenuPresenter do
    let(:menu) { create(:menu) }
    let(:subject) { JSON.parse(MenuPresenter.new(menu).to_json) }
    let(:expected_result) { 
      HashWithIndifferentAccess.new({
        id: menu.id,
        name: menu.name,
        price: menu.price,
        image: menu.image.urls,
        category: (MenuCategoryPresenter.new(menu.menu_category).as_json if menu.menu_category),
        components: ArrayPresenter.new(menu.menu_components, MenuComponentPresenter).as_json
      })
    }

    describe '#as_json' do
      it 'should build json presenter for menu' do
        expect(subject).to eq expected_result
      end
    end
  end
end
