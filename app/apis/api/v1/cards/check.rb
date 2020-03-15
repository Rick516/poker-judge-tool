module API
    module V1
        module Cards
            class Check < Grape::API
                resource :cards do
                    # post /api/v1/cards/check
                    desc 'judge strength and best'
                    #Once we add parameters requirements, grape will start returning only the declared parameters.
                    params do
                        requires :cards, type: Array[String]
                    end

                    post :check, 'cards/check' do
                        # 配列card_setsを定義しparamsを代入
                        card_sets = params[:cards]
                        # 配列cardsを定義しJudgeCardをnewして代入
                        cards = []
                        # cardsetを配列として代入
                        card_sets.each do |card_set|
                            cards.push JudgeService::JudgeCard.new(card_set: card_set)
                        end
                        # 各手札にstrengthを付与する
                        cards.each do |card|
                            card.judge_strength
                        end
                        # 最も強い手札にのみbest = true, 
                        JudgeService::JudgeCard.judge_best(cards)    

                    end
                end      
            end
        end
    end
end