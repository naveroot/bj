require_relative 'deck'
require_relative 'player'
require_relative 'dealer'
class Game
  include Deck
  attr_reader :player, :dealer, :status

  def initialize(username: 'Player')
    @dealer = Dealer.new
    @player = Player.new name: username
    @deck = Deck.generate
    @bank = 0
    @bank += @player.bet 10
    @bank += @dealer.bet 10
    @player.cards.concat @deck.pop(2)
    @dealer.cards.concat @deck.pop(2)
    @status = { action: :player_turn,
                params: { player_cards: @player.cards,
                          player_value: value(@player.cards),
                          player_cash: @player.cash,
                          bank: @bank } }
  end

  def command(command); end

  private

  def value(cards)
    value = 0
    cards.sort_by! { |card| Deck::VALUES.index(card[-1]) }
    cards.each do |card|
      value += if card[-1] == 'A'
                 ace_points value
               elsif card[-1].to_i > 0
                 card[-1].to_i
               else
                 10
               end
    end
    value
  end

  def ace_points(current_value)
    current_value > 10 ? 1 : 11
  end

  def game_over?
    @player.cash.zero? || @dealer.cash.zero?
  end
end
