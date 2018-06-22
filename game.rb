require_relative 'deck'
require_relative 'player'
require_relative 'dealer'
class Game
  include Deck
  attr_reader :player, :dealer

  def initialize(username: 'Player')
    @dealer = Dealer.new
    @player = Player.new name: username
  end

  def status
    :game_over if game_over?
  end

  def command(command); end

  private

  def game_over?
    @player.cash.zero? || @dealer.cash.zero?
  end
end
