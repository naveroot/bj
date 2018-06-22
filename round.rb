class Round
  def initialize(player, dealer, deck)
    @player = player
    @dealer = dealer
    @deck = deck
  end

  def start
    make_bets
    take_cards
  end

  def make_bets
    @dealer[:cash] -= 10
    @player[:cash] -= 10
  end

  def take_cards
    @dealer[:hand] = @deck.pop(2)
    @player[:hand] = @deck.pop(2)
  end

end