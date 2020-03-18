module JudgeService
    class JudgeCard
        include ActiveModel::Model
        require 'constants_service'
        include ConstantsService
        attr_accessor :card_set, :best, :cards
        attr_reader :hand, :strength, :result

        @@cards = Array.new
        @@cards = []
        def initialize(class_card)
            @@cards << class_card
        end
        def self.cards
            @@cards
        end

        def judge_role
            # card_setをカード毎に配列の要素として分割
            cards = card_set.split(" ")
            suits = []
            numbers = []
            cards.each do |card|
                suits << card[0]
                numbers << card[1..-1].to_i
            end
            # ストレートを判定
            steps = numbers.sort.map{|n|n - numbers[0]}
            if steps == [0,1,2,3,4] || steps == [0,9,10,11,12]
                straight = true
            else
                straight = false
            end
            # フラッシュを判定
            suit_set = suits.uniq.size
            if suit_set == 1
                flush = true
            else
                flush = false
            end
            # 重複したnumbersの数を数える
            number_set = numbers.group_by{|n|n}.map{|k,v|v.size}.sort.reverse
            # 役の判定
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

        # 強さを判定
        def judge_strength
            @strength = HANDS_STRENGTH.index(@hand) 
        end

        def self.judge_best(cards)
            scores = []
        
            cards.each do |card|
                scores.push card.strength.to_i
            end
        
            high_score =  scores.max

            (0..cards.length-1).each do |i|
                if cards[i].strength == high_score
                    cards[i].best = true
                else
                    cards[i].best = false
                end
            end
        end

        validate :validate_card_set

        def validate_card_set
            if card_set.blank?
                errors[:base] << ERR_MSG
            elsif card_set.match(VALID_REGEX).nil?
                rgx_set = card_set.split.reject{|r|r.match(/\A[SHDC]([1-9]|1[0-3])\z/)}
                (0..rgx_set.length-1).each do |i|
                    rgx_idx = card_set.split.index(rgx_set[i]).to_i + 1
                    errors[:base] << " #{ rgx_idx } " + INDEX_ERR_MSG + "(#{ rgx_set[i] } )"
                    errors[:base] << ERR_MSG
                end
            elsif card_set.split.size > card_set.split.uniq.size
                errors[:base] << IDENTICAL_ERR
            end
        end
    end
end