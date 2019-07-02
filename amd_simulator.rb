require_relative 'attack_modifier_deck'
require_relative 'amd_generator'

module AMDSimulator
  def self.run(**args)
    turns = args[:turns] || 10
    attacks_per_turn = args[:attacks_per_turn] || 1
    base = args[:base] || 3
    deck = args[:deck] || AttackModifierDeck.new
    turns_per_scenario = args[:turns_per_scenario] || 15
    scenario_reshuffle = args[:scenario_reshuffle] || false
    rules = args[:rules] || "raw"
    status = args[:status] || "advantage"
    log = args[:log] || false

    sum = 0.0
    deck.reshuffle

    puts "Starting simulation with" if log
    puts "deck: #{deck.print}" if log
    puts "discard: #{deck.print(:discard)}" if log

    turns.times do |turn|
      attacks_per_turn.times do |attack|
        puts "\nturn #{turn+1} attack #{attack+1}" if log

        if status == "normal"
          sum += raw_normal(deck, base, log)
        elsif rules == "raw" && status == "advantage"
          sum += raw_advantage(deck, base, log)
        elsif rules == "two-stack" && status == "advantage"
          sum += two_stack_advantage(deck, base, log)
        else
          puts "unkown or unimplemented rules and/or status"
        end

        puts "deck: #{deck.print(:remaining)}" if log
        puts "discard: #{deck.print(:discard)}" if log
      end

      if deck.reshuffle_in_discard? || (scenario_reshuffle && turn % turns_per_scenario == 0)
        puts "reshuffling" if log
        deck.reshuffle
      end
    end
    average_damage = sum / (turns * attacks_per_turn)
    results = {
      turns: turns,
      attacks_per_turn: attacks_per_turn,
      base_damage: base,
      rules: rules,
      status: status,
      average_damage: average_damage.round(2),
      additional_damage: (average_damage - base).round(2),
      percent_additional_damage: (average_damage / base - 1).round(2)
    }
  end

  def self.two_stack_advantage(deck, base, log)
    first_stack = []
    loop do
      modifier = deck.draw
      first_stack.push modifier
      break unless modifier.is_rolling?
    end
    second_stack = []
    loop do
      modifier = deck.draw
      second_stack.push modifier
      break unless modifier.is_rolling?
    end
    puts "drew first_stack: #{first_stack.map { |mod| mod.id }.inspect}, second stack: #{second_stack.map { |mod| mod.id }.inspect}" if log

    first_terminal = first_stack.pop
    first_attack = base
    first_stack.each do |modifier|
      first_attack += modifier.attack_value
    end
    first_attack = first_terminal.attack_value(first_attack)

    second_terminal = second_stack.pop
    second_attack = base
    second_stack.each { |modifier| second_attack += modifier.attack_value }
    second_attack = second_terminal.attack_value(second_attack)

    if first_attack >= second_attack
      puts "first stack selected, base: #{base}, first attack: #{first_attack}, second attack: #{second_attack}" if log
      first_attack
    else
      puts "second stack selected, base: #{base}, first attack: #{first_attack}, second attack: #{second_attack}" if log
      second_attack
    end
  end

  def self.raw_advantage(deck, base, log)
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
      puts "additional draws: #{additional_modifiers.map { |mod| mod.id }.inspect}" if log
      attack_value = base + first_modifier.attack_value + second_modifier.attack_value
      additional_modifiers.each do |modifier|
        attack_value += modifier.attack_value if modifier.is_rolling?
      end
      terminal = additional_modifiers.reject { |modifier| modifier.is_rolling? }.first
      attack_value = terminal.attack_value(attack_value)
      puts "two+ RMs drawn, base: #{base}, attack value: #{attack_value}" if log
      attack_value
    elsif first_modifier.is_rolling?
      attack_value = base + first_modifier.attack_value
      attack_value = second_modifier.attack_value(attack_value)
      puts "first modifier is RM, base: #{base}, attack value: #{attack_value}" if log
      attack_value
    elsif second_modifier.is_rolling?
      attack_value = base + second_modifier.attack_value
      attack_value = first_modifier.attack_value(attack_value)
      puts "second modifier is RM, base: #{base}, attack value: #{attack_value}" if log
      attack_value
    else
      first_attack = first_modifier.attack_value(base)
      second_attack = second_modifier.attack_value(base)

      if first_attack >= second_attack
        puts "best: #{first_modifier.id}, base: #{base}, attack value: #{first_attack}" if log
        first_attack
      else
        puts "best: #{second_modifier.id}, base: #{base}, attack value: #{second_attack}" if log
        second_attack
      end
    end
  end

  def self.raw_normal(deck, base, log)
    attack_value = base
    drawn_modifiers = []

    loop do
      modifier = deck.draw
      drawn_modifiers.push modifier
      break unless modifier.is_rolling?
    end

    puts "draws: #{drawn_modifiers.map { |mod| mod.id }.inspect}" if log

    terminal = drawn_modifiers.pop
    drawn_modifiers.each do |modifier|
      attack_value += modifier.attack_value
    end
    attack_value = terminal.attack_value(attack_value)
    puts "base: #{base}, attack value: #{attack_value}" if log
    attack_value
  end
end
