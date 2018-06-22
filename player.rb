class Player
  attr_reader :name, :cards
  attr_accessor :cash
  def initialize(name: 'Player')
    @name = name
    @cash = 100
    @cards = []
  end

  def bet(bet)
    @cash -= bet
    bet
  end

  def drop_hand
    @cards = []
  end

end