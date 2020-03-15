require 'rails_helper'

RSpec.describe JudgeService do 
    describe 'validate_card_set' do
        context 'S,H,D,Cと1..13からなるカード5枚で手札が構成されている場合' do
            it '手札が有効である' do
                card = JudgeService::JudgeCard.new(card_set: 'C7 C6 C5 C4 C3')
                expect(card).to be_valid
            end
        end
        context 'S,H,D,Cと1..13からなるカード6枚以上で手札が構成されている場合' do
            it 'INDEX_ERR_MSGが表示される' do
                card = JudgeService::JudgeCard.new(card_set: 'C7 C6 C5 C4 C3 C2')
                expect(card).not_to be_valid
            end
        end
        context 'S,H,D,Cと1..13からなるカード1枚以上4枚以下で手札が構成されている場合' do
            it 'INDEX_ERR_MSGが表示される' do
                card = JudgeService::JudgeCard.new(card_set: 'C7 C6 C5 C4')
                expect(card).not_to be_valid
            end
        end
        context '手札にカードが一枚も存在しない場合' do
            it 'ERR_MSGが表示される' do
                card = JudgeService::JudgeCard.new(card_set: "")
                expect(card).not_to be_valid
            end
        end
        context '手札を仕切るスペースが連続している場合' do
            it 'INDEX_ERR_MSGが表示される' do
                card = JudgeService::JudgeCard.new(card_set: 'C7  C6 C5 C4 C3')
                expect(card).not_to be_valid
            end
        end
        context '手札がスペース以外で仕切られている場合' do
            it 'INDEX_ERR_MSGが表示される' do
                card = JudgeService::JudgeCard.new(card_set: 'C7,C6,C5,C4,C3')
                expect(card).not_to be_valid
            end
        end
        context 'S,H,D,C以外と1..13からなるカードで手札が構成されている場合' do
            it 'INDEX_ERR_MSGが表示される' do
                card = JudgeService::JudgeCard.new(card_set: 'A7 C6 C5 C4 C3')
                expect(card).not_to be_valid
            end
        end
        context 'S,H,D,Cと1..13以外からなるカードで手札が構成されている場合' do
            it 'INDEX_ERR_MSGが表示される' do
                card = JudgeService::JudgeCard.new(card_set: 'C14 C6 C5 C4 C3')
                expect(card).not_to be_valid
            end
        end
    end

    describe 'judge_role' do
        context '手札の役がストレートフラッシュである場合' do
            it '"ストレートフラッシュ"を返す' do
                card = JudgeService::JudgeCard.new(card_set: 'C1 C2 C3 C4 C5')
                expect(card.judge_role).to eq "ストレートフラッシュ"
            end
        end
        context '手札の役がフラッシュである場合' do
            it '"フラッシュ"を返す' do
                card = JudgeService::JudgeCard.new(card_set: 'H1 H12 H10 H5 H3')
                expect(card.judge_role).to eq "フラッシュ"
            end
        end
        context '手札の役がストレートである場合' do
            it '"ストレート"を返す' do
                card = JudgeService::JudgeCard.new(card_set: 'S1 H13 D12 C11 H10')
                expect(card.judge_role).to eq "ストレート"
            end
        end
        context '手札の役がである場合' do
            it '"フォー・オブ・ア・カインド"を返す' do
                card = JudgeService::JudgeCard.new(card_set: 'C10 D10 H10 S10 D5')
                expect(card.judge_role).to eq "フォー・オブ・ア・カインド"
            end
        end
        context '手札の役がフルハウスである場合' do
            it '"フルハウス"を返す' do
                card = JudgeService::JudgeCard.new(card_set: 'S10 H10 D10 S4 D4')
                expect(card.judge_role).to eq "フルハウス"
            end
        end
        context '手札の役がスリー・オブ・ア・カインドである場合' do
            it '"スリー・オブ・ア・カインド"を返す' do
            card = JudgeService::JudgeCard.new(card_set: 'S12 C12 D12 S5 C3')
            expect(card.judge_role).to eq "スリー・オブ・ア・カインド"
            end
        end
        context '手札の役がツーペアである場合' do
            it '"ツーペア"を返す' do
            card = JudgeService::JudgeCard.new(card_set: 'H1 D1 C2 D2 H5')
            expect(card.judge_role).to eq "ツーペア"
            end
        end
        context '手札の役がワンペアである場合' do
            it '"ワンペア"を返す' do
            card = JudgeService::JudgeCard.new(card_set: 'C10 S10 S6 H4 H2')
            expect(card.judge_role).to eq "ワンペア"
            end
        end
        context '手札の役がハイカードである場合' do
            it '"ハイ・カード"を返す' do
            card = JudgeService::JudgeCard.new(card_set: 'D1 D10 S9 C5 C4')
            expect(card.judge_role).to eq "ハイ・カード"
            end
        end
    end
end