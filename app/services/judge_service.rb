module JudgeService 
    class JudgeCard
        include ActiveModel::Model
        require 'constants_service'
        include ConstantsService
        attr_accessor :card_set, :best
        attr_reader :hand, :cards, :strength, :result, :hashed_result, :error_api

        def judge_role
            # split cardset
            @cards = card_set.split(" ")
            suits = []
            numbers = []
            @cards.each do |card|
                suits.push card[0]
                numbers.push card[1..-1].to_i
            end
            # check_straight
            steps = numbers.sort.map{|n|n - numbers[0]}
            if steps == [0,1,2,3,4] || steps == [0,9,10,11,12]
                straight = true
            else
                straight = false
            end
            # check flush
            suit_set = suits.uniq.size
            if suit_set == 1
                flush = true
            else
                flush = false
            end
            # count same numbers
            number_set = numbers.group_by{|n|n}.map{|k,v|v.size}.sort.reverse
            # judge hands
            if straight == true && flush == true
                @hand = STRAIGHT_FLUSH
            elsif straight == false && flush == true
                @hand = FLUSH
            elsif straight == true && flush == false
                @hand = STRAIGHT
            else
                case number_set
                when [4, 1]
                    @hand = FOUR_OF_A_KIND
                when [3, 2]
                    @hand = FULLHOUSE
                when [3, 1, 1]
                    @hand = THREE_OF_A_KIND
                when [2, 2, 1]
                    @hand = TWO_PAIR
                when [2, 1, 1, 1]
                    @hand = ONE_PAIR
                else
                    @hand = HIGH_CARD
                end
            end
        end
        
        def judge_strength
            judge_role 
            @strength = HANDS_STRENGTH.index(@hand)
            @best = true
        end
    
        def self.judge_best(cards)
            scores = []
        
            cards.each do |card|
                scores.push card.strength.to_i
            end
        
            high_score =  scores.max

            for i in 0..(cards.length-1) do
                if cards[i].strength == high_score
                    cards[i].best = true
                else
                    cards[i].best = false
                end
            end

            result = []
            for i in 0..cards.length-1 do 
                result.push({
                    "card": cards[i].card_set,
                    "hand": cards[i].hand,
                    "best": cards[i].best
                    })
            end

            hashed_result = {"result": result}
            return hashed_result
        end

        validate :validate_card_set

        def validate_card_set
            if card_set.blank?
                errors[:base] << ERR_MSG
                error_api = ERR_MSG
            elsif card_set.match(VALID_REGEX).nil?
                rgx_set = card_set.split.reject{|r|r.match(/\A[SHDC]([1-9]|1[0-3])\z/)}
                rgx_idx = card_set.split.index(rgx_set[0]).to_i + 1
                errors[:base] << " #{ rgx_idx } " + INDEX_ERR_MSG + "(#{ rgx_set[0] } )"
                errors[:base] << ERR_MSG
                error_api = " #{ rgx_idx } " + INDEX_ERR_MSG + "(#{ rgx_set[0] } )" + ERR_MSG
            elsif card_set.split.size > card_set.split.uniq.size
                errors[:base] << IDENTICAL_ERR
                error_api = IDENTICAL_ERR
            else 
                error_api = nil
            end
        end   
    end
end