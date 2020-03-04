module JudgeService 
    class JudgeCard
        include ActiveModel::Model

        attr_accessor :card_set, :cards, :suits, :numbers, :number_set, :flush, :straight, :hand, :steps
    
        POKER_HANDS = ["ハイカード", "ワンぺア", "ツーペア", "スリー・オブ・ア・カインド", "ストレート", "フラッシュ", "フルハウス", "フォー・オブ・ア・カインド", "ストレートフラッシュ"]
        VALID_REGEX = /\A[SHDC]([1-9]|1[0-3]) [SHDC]([1-9]|1[0-3]) [SHDC]([1-9]|1[0-3]) [SHDC]([1-9]|1[0-3]) [SHDC]([1-9]|1[0-3])\z/
    
        validate :validate_card_set
        
        def validate_card_set
            if @card_set.blank?
                errors[:base] << "5つのカード指定文字を半角スペース区切りで入力してください。（例：'S1 H3 D9 C13 S11')"
            elsif @card_set.match(VALID_REGEX) == nil
                @rgx_set = @card_set.split.reject{|r|r.match(/\A[SHDC]([1-9]|1[0-3])\z/)}
                @rgx_idx = @card_set.split.index(@rgx_set[0]).to_i + 1
                errors[:base] << " #{ @rgx_idx } 番目のカード指定文字が不正です。(#{@rgx_set[0]})  半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
            elsif @card_set.split.size > @card_set.split.uniq.size
                errors[:base] << "カードが重複しています。"
            end
        end
        def judge_role
            split_card_set
            straight?
            flush?
            count_same_number
            judge_hand
        end
    
        def split_card_set()
            @cards = @card_set.split(" ")
    
            @suits = []
            @numbers = []
    
            @cards.each do |card|
                @suits.push card[0]
                @numbers.push card[1..-1].to_i
            end
        end

        def straight?()
            @steps = @numbers.sort.map{|n|n - @numbers[0]}
            if @steps == [0,1,2,3,4] || @steps == [0,9,10,11,12]
                @straight = true
            else
                @straight = false
            end
        end
    
        def flush?()
            suit_set = @suits.uniq.size
            if suit_set == 1
                @flush = true
            else
                @flush = false
            end
        end
    
        def count_same_number()
            @number_set = @numbers.group_by{|n|n}.map{|k,v|v.size}.sort.reverse
        end
    
        def judge_hand()
            case [@straight, @flush]
            when [true, true]
                @hand = POKER_HANDS[8]
            when [false, true]
                @hand = POKER_HANDS[5]
            when [true, false]
                @hand = POKER_HANDS[4]
            else
                case @number_set
                when [4, 1]
                    @hand = POKER_HANDS[7]
                when [3, 2]
                    @hand = POKER_HANDS[6]
                when [3, 1, 1]
                    @hand = POKER_HANDS[3]
                when [2, 2, 1]
                    @hand = POKER_HANDS[2]
                when [2, 1, 1, 1]
                    @hand = POKER_HANDS[1]
                else
                    @hand = POKER_HANDS[0]
                end
            end
        end
    end
end
