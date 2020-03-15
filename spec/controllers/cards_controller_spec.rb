require 'rails_helper'

RSpec.describe CardsController, type: :controller do 
    describe "get #top" do
        
        before do
            get :top
        end
        it '@cardに新しい手札を割り当てる' do
            expect(assigns(:card)).not_to be_nil
        end
        it ':topテンプレートを表示する' do
            expect(response).to render_template :top
        end
        it 'ステータスコードが200 OKとなる' do
            expect(response.status).to eq 200
        end
    end

    describe 'Post #check' do
        let(:card) { JudgeCard.new(card_params) }
        let(:card_params) { { card_set: card_set } }
        context '有効なパラメータの場合' do
            before do
                card_set = 'C7 C6 C5 C4 C3'
                post :check, params: { card_set: card_set }
            end
            it ':resultテンプレートを表示する' do
                expect(response).to render_template :result
            end
            it 'ステータスコードが200 OKとなる' do
                expect(response.status).to eq 200
            end
        end

        context '無効なパラメータの場合' do
            before do
                card_set = ''
                post :check, params: {card_set: card_set}
            end
            it ':errorテンプレートを表示する' do
                expect(response).to render_template :error
            end
            it 'ステータスコードが200 OKとなる' do
                expect(response.status).to eq 200
            end
        end
    end
end