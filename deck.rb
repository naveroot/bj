module Deck
  SUITS = %w[♥ ♦ ♣ ♠].freeze
  VALUES = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

  def self.generate
    @cards = []
    SUITS.each do |suit|
      VALUES.each do |value|
        @cards << [suit, value]
      end
    end
    @cards.shuffle!
  end
end