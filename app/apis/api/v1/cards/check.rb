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
                    attr_accessor :card_set, :best, :cards
                    attr_reader :hand, :strength, :result
                    # post /api/v1/cards/check
                    desc 'judge strength and best'

                    #入力バリデーション
                    params do
                        requires :cards, type: Array[String]
                    end

                    post :check, 'cards/check' do
                        card_sets = params[:cards]

                        card_sets.each do |card_set|
                            JudgeCard.new(card_set: card_set)
                        end

                        #judge call
                        JudgeCard.cards.each do |card|
                            card.judge_role
                            card.judge_strength
                            JudgeCard.judge_best(JudgeCard.cards)
                        end

                        # json response
                        hashed_result = {}
                        hashed_result[:result] = []
                        hashed_result[:error] = []
                        JudgeCard.cards.each do |card|
                            if card.validate_card_set == nil
                                hashed_result[:result] << {
                                    "card": card.card_set,
                                    "hand": card.hand,
                                    "best": card.best
                                }
                            else
                                hashed_result[:error] << {
                                    "card": card.card_set,
                                    "msg": card.errors[:base]
                                }
                            end
                        end
                        return hashed_result
                    end
                end      
            end
        end
    end
end