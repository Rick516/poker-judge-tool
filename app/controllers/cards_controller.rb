class CardsController < ApplicationController

    def top
        @card = Card.new
        # インスタンス変数はビューでも参照できる
    end

    def result
    end

    def check
        @card = Card.new(card_params)
        if @card.valid?
            @card.judge_role
            render :result
        else 
            render :error
        end
    end

    def error 
    end
        
    private
    def card_params
        params.require(:card).permit(:card_set)
    end
end