require_relative 'game'
class BlackJack
  def start
    puts 'Please, enter your name:'
    @username = gets.chomp
    @game = Game.new username: @username
    loop do
      status = @game.status
      case status[:action]
      when :player_turn
        @game.command player_choice(status[:params])
      when :winner
        winner status[:params]
        continue? ? @game.command(:new_round) : break
      when :draw
        draw status[:params]
        continue? ? @game.command(:new_round) : break
      when :game_over
        game_over status[:params]
        continue? ? @game.command(:new_game) : break
      end
    end
  end

  private

  def player_choice(params)
    game_menu params
    action_menu params
    case prompt.to_i
    when 1
      :open_cards
    when 2
      :pass
    when 3
      :add_one_card
    else
      raise 'wrong_params'
    end
  end

  def prompt
    print '$: '
    gets.chomp
  end

  def game_menu(params)
    puts '==============================================='
    puts "#{@username}"
    puts "Cards: #{params[:player_cards]}"
    puts "Value: #{params[:player_value]}"
    puts "Cash: #{params[:player_cash]}"
    puts '==============================================='
    puts "Dealer"
    puts "Cards: #{params[:dealer_cards] ? params[:dealer_cards] : '??'}"
    puts "Value: #{params[:dealer_value] ? params[:dealer_value] : '??'}"
    puts "Cash: #{params[:dealer_cash] ? params[:dealer_cash] : '??'}"
    puts '==============================================='
    puts "Bank: #{params[:bank]}"
  end

  def winner(params)
    game_menu(params)
    puts '==============================================='
    puts "The winner is #{params[:winner]}"
    puts '==============================================='
  end

  def game_over(params)
    puts '==============================================='
    puts "Game over! #{params[:loser]} spend all his money!"
    puts '==============================================='
  end

  def draw(params)
    game_menu(params)
    puts '==============================================='
    puts "Draw"
    puts '==============================================='
  end

  def action_menu(params)
    puts 'Choice your action:'
    puts '1: Open cards'
    puts '2: Pass'
    puts '3: Add one card' if params[:player_cards].size < 3
  end

  def continue?
    puts "Do you want to continue?"
    puts "1: Yes"
    puts "2: No"
    prompt.to_i == 1
  end
end

bj = BlackJack.new
bj.start
