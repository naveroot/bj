class Player
  attr_reader :name, :cash, :cards
  def initialize(name: 'Player')
    @name = name
    @cash = 100
    @cards = []
  end

  def bet(bet)
    @cash -= bet
    bet
  end

end