class CardsController < ApplicationController
    include JudgeService
    
    def top
        @card = JudgeCard.new
    end

    def check
        @card = JudgeCard.new(card_params)
        if @card.valid?
            @card.judge_role
            render :result
        else 
            render :error
        end
    end

    private

    def card_params
        params.permit(:card_set)
    end
end