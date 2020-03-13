class CardsController < ApplicationController
    include JudgeService
    
    def top
        @card = JudgeCard.new
    end

    def check
        @card = JudgeCard.new(card_params)
        if @card.valid?
            @card.judge_role
            render :result, :sstatus => 200
        else 
            render :error, :status => 200
        end
    end

    private

    def card_params
        params.permit(:card_set)
    end
end