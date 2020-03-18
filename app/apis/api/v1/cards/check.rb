module API
    module V1
        module Cards
            class Check < Grape::API
                resource :cards do
                    require 'judge_service'
                    include JudgeService 
                    require 'constants_service'
                    include ConstantsService
                    include ActiveModel::Model
                    # post /api/v1/cards/check
                    desc 'judge strength and best'
                    #入力バリデーション
                    params do
                        requires :cards, type: Array[String]
                    end

                    post :check, 'cards/check' do
                        card_sets = params[:cards]

                        cards = []  

                        card_sets.each do |card_set|
                            cards << JudgeCard.new(card_set: card_set)
                        end
                        
                        cards.each do |card|
                            card.judge_role
                            card.judge_strength
                            card.validate_card_set
                            JudgeCard.judge_best(cards)
                        end
                        
                        result = []
                        error = []
                        (0..cards.length-1).each do |i| 
                            if cards[i].errors[:base] == nil
                                @result << ({  
                                    "card": "www"
                            #         # "card": cards[i].card_set
                            #         # cards[i].hand,
                            #         # cards[i].best
                                })
                            else
                                @error << ({
                                    "np2": cards[2].errors[:base]
                            #         # cards[i].card_set,
                            #         # cards[i].errors[:base]
                                })
                            end
                            p cards[i].card_set
                        end

                        # p cards[2].errors[:base]

                        # cards << {"strength": HANDS_STRENGTH.index(cards[0].hand)}
                        # # JudgeCard.judge_best(cards)   
                        # p HANDS_STRENGTH.index(cards[0].hand)
                        
                        # def result_json(cards)
                        #     @result = []
                        #     @error = []
                        #     (0..cards.length-1).each do |i|
                        #         if cards[i].validate_card_set == nil
                        #             @result << ({
                        #                 "card": cards[i].card_set,
                        #                 "hand": cards[i].hand,
                        #                 "best": cards[i].best
                        #                 })
                        #         else
                        #             @error << ({
                        #                 "card": cards[i].card_set,
                        #                 "msg": cards[i].err_msg
                        #             })
                        #         end
                        #         # hashed_result = {"result": result}
                        #         # cards.map{ |card|
                        #         #     if card.validate_card_set != nil
                        #         #         hashed_result.store("error", error)
                        #         #     end
                        #         # }
                                
                        #         # return hashed_result
                        #     end     
                        # end

                        # hashed_result = {"result": @result}
                        # cards.map{ |card|
                        #     if card.validate_card_set != nil
                        #         hashed_result.store("error", @error)
                        #     end
                        # }
                        # error =[]
                        # error.store({msg: cards[2].errors[:base]})
                    end
                end      
            end
        end
    end
end