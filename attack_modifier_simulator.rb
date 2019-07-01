require_relative 'attack_modifier_deck'

module AttackModifierSimulator
  def self.raw_advantage(**args)
    turns = args[:turns] || 10
    attacks_per_turn = args[:attacks_per_turn] || 1
    base = args[:base] || 3
    deck = args[:deck] || AttackModifierDeck.new
    turns_per_scenario = args[:turns_per_scenario] || 15
    log = args[:log] || false

    sum = 0.0
    reshuffle = false
    deck.shuffle

    turns.times do |turn|
      attacks_per_turn.times do |attack|
        puts "\nturn #{turn+1} attack #{attack+1}" if log
        puts "deck: #{deck.deck.inspect}" if log
        puts "discard: #{deck.discard.inspect}" if log

        first_modifier = deck.draw
        second_modifier = deck.draw
        additional_modifiers = []

        puts "draws: #{first_modifier}, #{second_modifier}" if log

        # if deck.is_rolling?(first_modifier) && deck.is_rolling?(second_modifier)
        #   loop do
        #     new_modifier = deck.draw
        #     additional_modifiers.push new_modifier
        #     break unless deck.is_rolling?(new_modifier)
        #   end
        # # elsif deck.is_rolling?(first_modifier) || deck.is_rolling?(second_modifier)
        # end

        first_attack = deck.attack_value(first_modifier, base)
        second_attack = deck.attack_value(second_modifier, base)

        if first_attack >= second_attack
          puts "best: #{first_modifier}, attack value: #{first_attack}" if log
          sum += first_attack
        else
          puts "best: #{second_modifier}, attack value: #{second_attack}" if log
          sum += second_attack
        end

        if deck.is_reshuffle?(first_modifier) || deck.is_reshuffle?(second_modifier)
          reshuffle = true
        end
      end

      reshuffle = true if turn % turns_per_scenario == 0

      if reshuffle
        puts "reshuffling" if log
        deck.reshuffle
        reshuffle = false
      end
    end
    average_damage = sum / (turns * attacks_per_turn)
    {
      average_damage: average_damage,
      additional_damage_from_advantage: average_damage - base,
      percent_additional_damage_from_advantage: average_damage / base - 1
    }
  end
end
