module ConstantsService
    ERR_MSG = "5つのカード指定文字を半角スペース区切りで入力してください。（例：'S1 H3 D9 C13 S11')"
    INDEX_ERR_MSG = "番目のカード指定文字が不正です。"
    IDENTICAL_ERR = "カードが重複しています。"
    VALID_REGEX = /\A[SHDC]([1-9]|1[0-3]) [SHDC]([1-9]|1[0-3]) [SHDC]([1-9]|1[0-3]) [SHDC]([1-9]|1[0-3]) [SHDC]([1-9]|1[0-3])\z/

    HIGH_CARD = "ハイ・カード"
    ONE_PAIR = "ワンペア"
    TWO_PAIR = "ツーペア"
    THREE_OF_A_KIND = "スリー・オブ・ア・カインド"
    STRAIGHT = "ストレート"
    FLUSH = "フラッシュ"
    FULLHOUSE = "フルハウス"
    FOUR_OF_A_KIND = "フォー・オブ・ア・カインド"
    STRAIGHT_FLUSH = "ストレートフラッシュ"
end



