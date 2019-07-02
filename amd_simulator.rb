require_relative 'attack_modifier_deck'
require_relative 'amd_generator'

module AMDSimulator
  def self.raw_advantage(**args)
    turns = args[:turns] || 10
    attacks_per_turn = args[:attacks_per_turn] || 1
    base = args[:base] || 3
    deck = args[:deck] || AttackModifierDeck.new
    turns_per_scenario = args[:turns_per_scenario] || 15
    log = args[:log] || false

    sum = 0.0
    reshuffle = false
    deck.reshuffle

    puts "Starting simulation with" if log
    puts "deck: #{deck.print}" if log
    puts "discard: #{deck.print(:discard)}" if log

    turns.times do |turn|
      attacks_per_turn.times do |attack|
        puts "\nturn #{turn+1} attack #{attack+1}" if log

        first_modifier = deck.draw
        second_modifier = deck.draw
        additional_modifiers = []

        puts "draws: #{first_modifier.id}, #{second_modifier.id}" if log

        if first_modifier.is_rolling? && second_modifier.is_rolling?
          loop do
            new_modifier = deck.draw
            additional_modifiers.push new_modifier
            break unless new_modifier.is_rolling?
          end
          puts "additional draws: #{additional_modifiers.map { |mod| mod.id }.inspect}"
          attack_value = base + first_modifier.attack_value + second_modifier.attack_value
          additional_modifiers.each do |modifier|
            attack_value += modifier.attack_value if modifier.is_rolling?
          end
          terminal = additional_modifiers.reject { |modifier| modifier.is_rolling? }.first
          attack_value = terminal.attack_value(attack_value)
          puts "two+ RMs drawn, attack value: #{attack_value}"
          sum += attack_value
        elsif first_modifier.is_rolling?
          attack_value = base + first_modifier.attack_value
          attack_value = second_modifier.attack_value(attack_value)
          puts "first modifier is RM, attack value: #{attack_value}"
          sum += attack_value
        elsif second_modifier.is_rolling?
         attack_value = base + second_modifier.attack_value
         attack_value = first_modifier.attack_value(attack_value)
         puts "second modifier is RM, attack value: #{attack_value}"
         sum += attack_value
        else
          first_attack = first_modifier.attack_value(base)
          second_attack = second_modifier.attack_value(base)

          if first_attack >= second_attack
            puts "best: #{first_modifier.id}, attack value: #{first_attack}" if log
            sum += first_attack
          else
            puts "best: #{second_modifier.id}, attack value: #{second_attack}" if log
            sum += second_attack
          end
        end

        if first_modifier.is_reshuffle? || second_modifier.is_reshuffle? || additional_modifiers.select { |mod| mod.is_reshuffle? }.any?
          reshuffle = true
        end

        puts "deck: #{deck.print(:remaining)}" if log
        puts "discard: #{deck.print(:discard)}" if log
      end

      # reshuffle = true if turn % turns_per_scenario == 0

      if reshuffle
        puts "reshuffling" if log
        deck.reshuffle
        reshuffle = false
      end
    end
    average_damage = sum / (turns * attacks_per_turn)
    results = {
      turns: turns,
      base_damage: base,
      average_damage: average_damage.round(2),
      additional_damage_from_advantage: (average_damage - base).round(2),
      percent_additional_damage_from_advantage: (average_damage / base - 1).round(2)
    }
  end
end
