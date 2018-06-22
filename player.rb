class Player
  attr_reader :name, :cash
  def initialize(name: 'Player')
    @name = name
    @cash = 100
  end
end