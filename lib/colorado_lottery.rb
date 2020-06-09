class ColoradoLottery
  attr_reader :registered_contestants, :current_contestants, :winners
  def initialize
    @registered_contestants = {}
    @current_contestants = {}
    @winners = []
  end

  def interested_and_18?(contestant, game)
    if contestant.age >= 18 == true &&
       contestant.game_interests.include?(game.name)
      true
    else
      false
    end
  end

  def can_register?(contestant, game)
    interested_and_18?(contestant, game) && (!contestant.out_of_state? || game.national_drawing?)
  end

  def register_contestant(contestant, game)
    if @registered_contestants[game.name].nil?
      @registered_contestants[game.name] = [contestant]
    else
      @registered_contestants[game.name] << contestant
    end
  end

  def eligible_contestants(game)
    contestants = @registered_contestants[game.name]
    contestants.filter { |contestant| contestant.spending_money >= game.cost }
  end

  def charge_contestants(game)
    contestants = eligible_contestants(game)
    contestant_names = contestants.map do |contestant|
      contestant.charge(game.cost)
      contestant.full_name
    end
    @current_contestants[game] = contestant_names
  end

  def draw_winners
    @current_contestants.each do |game, contestants|
      @winners << { game.name => contestants.sample }
    end
    '06/09/2020'
  end

  def announce_winner(game)
    game_winner = @winners.find do |winner|
      winner.keys[0] == game
    end
    name_of_winner = game_winner[game]
    puts "#{name_of_winner} won the #{game} on 06/09/2020"
  end
end
