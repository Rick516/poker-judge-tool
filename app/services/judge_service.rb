module JudgeService 
    class JudgeCard
        include ActiveModel::Model
        require 'constants_service'
        include ConstantsService
        attr_accessor :card_set
        attr_reader :hand

        def judge_role
            # split cardset
            cards = card_set.split(" ")
            suits = []
            numbers = []
            cards.each do |card|
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

        private

        validate :validate_card_set

        def validate_card_set
            if card_set.blank?
                errors[:base] << ERR_MSG
            elsif card_set.match(VALID_REGEX).nil?
                rgx_set = card_set.split.reject{|r|r.match(/\A[SHDC]([1-9]|1[0-3])\z/)}
                rgx_idx = card_set.split.index(rgx_set[0]).to_i + 1
                errors[:base] << " #{ rgx_idx } " + INDEX_ERR_MSG + "(#{ rgx_set[0] } )"
                errors[:base] << ERR_MSG
            elsif card_set.split.size > card_set.split.uniq.size
                errors[:base] << IDENTICAL_ERR
            end
        end
    end
end