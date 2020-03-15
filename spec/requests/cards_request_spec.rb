require "rails_helper"

RSpec.describe "Check", type: :request do
    describe "POST /api/vi/cards/check" do
        context "有効なパラメータの場合" do
        before do
            cards = {"cards": ["C1 C2 C3 C4 C5", "H2 H4 D2 C2 C4"]}
            post "/api/v1/cards/check", params: cards
        end

        it "リクエストの成功に201を返す" do
            expect(response.status).to eq 201
        end

        it "card_set、hand、さらに最も強い役にはbest = true、それ以外にはfalseを返す" do
            json_body = JSON.parse(response.body)
            expect(json_body["result"][0]["card"]).to eq "C1 C2 C3 C4 C5"
            expect(json_body["result"][0]["hand"]).to eq "ストレートフラッシュ"
            expect(json_body["result"][0]["best"]).to eq true
            expect(json_body["result"][1]["card"]).to eq "H2 H4 D2 C2 C4"
            expect(json_body["result"][1]["hand"]).to eq "フルハウス"
            expect(json_body["result"][1]["best"]).to eq false
        end

        end

        context "無効な入力の場合" do
            before do
                cards = {"cards": ["C1 C2 C3 C4 C12121", "", "C1 C1 C2 C4 C5"]}
                post "/api/v1/cards/check", params: cards
            end

            it "リクエストの成功に201を返す" do
                expect(response.status).to eq 201
            end

            it "エラーメッセージを返す" do
                json_body = JSON.parse(response.body)
                expect(json_body["error"][0]["card"]).to eq "C1 C2 C3 C4 C12121"
                expect(json_body["error"][0]["msg"]).to eq " 5 番目のカード指定文字が不正です。(C12121 )5つのカード指定文字を半角スペース区切りで入力してください。（例：'S1 H3 D9 C13 S11')"
                expect(json_body["error"][1]["card"]).to eq ""
                expect(json_body["error"][1]["msg"]).to eq "5つのカード指定文字を半角スペース区切りで入力してください。（例：'S1 H3 D9 C13 S11')"
                expect(json_body["error"][2]["card"]).to eq "C1 C1 C2 C4 C5"
                expect(json_body["error"][2]["msg"]).to eq "カードが重複しています。"
            end

            end

            context "不正なURLの入力" do
            before do
                cards = {"cards": ["C7 C6 C5 C4 C3", "D1 D10 S9 C5 C4"]}
                post "/api/v1/check", params: cards
            end

            it "不正なリクエストは404 Not Foundとなる" do
                expect(response.status).to eq 404
            end

            it "エラーメッセージを返す" do
                json_body = JSON.parse(response.body)
                expect(json_body["error"]).to eq "404 Not Found：指定されたURLは存在しません"
            end
        end
    end
end