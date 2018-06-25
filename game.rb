require_relative 'deck'
require_relative 'player'
require_relative 'dealer'
class Game
  include Deck
  attr_reader :player, :status

  def initialize(username: 'Player')
    @dealer = Dealer.new
    @player = Player.new name: username
    @status = { action: :start_game, params: {} }
    new_round
  end

  def open_cards
    if draw?
      draw
    elsif value(@player.cards) > value(@dealer.cards)
      select_winner @player
    else
      select_winner @dealer
    end
    overflow_validation
    game_over_validation
  end

  def pass
    @dealer.cards.concat @deck.pop(1) if value(@dealer.cards) < 17 && @dealer.cards.size < 3
    status_builder :player_turn, player_info, bank
    overflow_validation
    game_over_validation
  end

  def add_one_card
    raise 'You have 3 cads. Y cant take more' if @player.cards.size > 2
    @player.cards.concat @deck.pop(1)
    status_builder :player_turn, player_info, bank
    overflow_validation
    game_over_validation
  end

  def new_round
    raise 'end round before start new' unless %i[winner draw game_over start_game].include? @status[:action]
    @deck = Deck.generate
    @bank = 0
    @bank += @player.bet 10
    @bank += @dealer.bet 10
    @player.drop_hand
    @dealer.drop_hand
    @player.cards.concat @deck.pop(2)
    @dealer.cards.concat @deck.pop(2)
    status_builder :player_turn, player_info, bank
    overflow_validation
    game_over_validation
  end

  def new_game
    raise 'end round before start new' unless %i[winner draw game_over start_game].include? @status[:action]
    @dealer.cash = 100
    @player.cash = 100
    new_round
    overflow_validation
    game_over_validation
  end

  private

  def player_info
    { player_cards: @player.cards,
      player_value: value(@player.cards),
      player_cash: @player.cash }
  end

  def dealer_info
    { dealer_cards: @dealer.cards,
      dealer_value: value(@dealer.cards),
      dealer_cash: @dealer.cash }
  end

  def bank
    { bank: @bank }
  end

  def select_winner(player)
    player.cash += @bank
    @bank = 0
    status_builder :winner, player_info, dealer_info, bank, winner: player.name
  end

  def draw
    @player.cash += 10
    @dealer.cash += 10
    @bank = 0
    status_builder :draw, player_info, dealer_info
  end

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

  def draw?
    value(@player.cards) == value(@dealer.cards)
  end

  def overflow_validation
    select_winner @dealer if value(@player.cards) > 21
    select_winner @player if value(@dealer.cards) > 21
  end

  def game_over_validation
    if @player.cash.zero?
      status_builder :game_over, player_info, dealer_info, loser: @player
    elsif @dealer.cash.zero?
      @status[:action] = :game_over
      status_builder :game_over, player_info, dealer_info, loser: @dealer
    end
  end

  def status_builder(action, *params)
    @status = { params: {} }
    @status[:action] = action
    params.each { |param| @status[:params].merge! param }
  end
end
