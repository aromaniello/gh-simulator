class AttackModifierDeck

  attr_accessor :deck
  attr_accessor :discard

  def initialize
    @deck = []
    @deck.push 'RSx0'
    @deck.push '-2'
    5.times { @deck.push '-1' }
    6.times { @deck.push '+0' }
    5.times { @deck.push '+1' }
    @deck.push '+2'
    @deck.push 'RSx2'
    @discard = []
  end

  def add_modifier(modifier, n=1)
    n.times do
      deck.push modifier
    end
  end

  def remove_modifier(modifier, n=1)
    n.times do
      # deck.delete_at deck.index(modifier) unless deck.index(modifier).nil?
      deck.slice!(deck.index(modifier))
    end
  end

  def shuffle
    deck.shuffle!
  end

  def average_damage(base=3)
    sum = 0.0
    deck.each do |mod|
      case mod
      when 'x0'
        sum += base
      when '-2'
        sum += base-2
      when '-1'
        sum += base-1
      when '+0'
        sum += base
      when '+1'
        sum += base+1
      when '+2'
        sum += base+2
      when 'x2'
        sum += base*2
      end
    end
    sum / deck.length
  end

  def attack_value(modifier, base=3)
    if modifier.include? 'x0'
      0
    elsif modifier.include? '-2'
      base-2
    elsif modifier.include? '-1'
      base-1
    elsif modifier.include? '+0'
      base
    elsif modifier.include? '+1'
      base+1
    elsif modifier.include? '+2'
      base+2
    elsif modifier.include? 'x2'
      base*2
    end
  end

  def is_reshuffle?(modifier)
    modifier.include? 'RS'
  end

  def is_rolling?(modifier)
    modifier.include? 'RM'
  end

  def reshuffle
    discard.each do |modifier|
      deck.push modifier
    end
    @discard = []
    shuffle
  end

  def draw
    reshuffle if deck.empty?
    modifier = deck.pop
    discard.push modifier
    modifier
  end

  # def simulate_draws_advantage(iterations=10, base=3, attacks_per_turn=1, log=false)
  #   shuffle
  #   sum = 0.0
  #   reshuffle_this_turn = false
  #   iterations.times do |turn|
  #     attacks_per_turn.times do |attack|
  #       puts "\nturn #{turn+1} attack #{attack+1}" if log
  #       puts "deck: #{deck.inspect}" if log
  #       puts "discard: #{discard.inspect}" if log
  #
  #       first_modifier = draw
  #       second_modifier = draw
  #
  #       puts "draws: #{first_modifier}, #{second_modifier}" if log
  #
  #       first_attack = attack_value(first_modifier, base)
  #       second_attack = attack_value(second_modifier, base)
  #
  #       if first_attack >= second_attack
  #         puts "best: #{first_modifier}, attack value: #{first_attack}" if log
  #         sum += first_attack
  #       else
  #         puts "best: #{second_modifier}, attack value: #{second_attack}" if log
  #         sum += second_attack
  #       end
  #
  #       if is_reshuffle?(first_modifier) || is_reshuffle?(second_modifier)
  #         reshuffle_this_turn = true
  #       end
  #     end
  #
  #     if reshuffle_this_turn
  #       puts "reshuffling" if log
  #       reshuffle
  #       reshuffle_this_turn = false
  #     end
  #   end
  #   average_damage = sum / (iterations * attacks_per_turn)
  #   {
  #     average_damage: average_damage,
  #     additional_damage_from_advantage: average_damage - base,
  #     percent_additional_damage_from_advantage: average_damage/base-1
  #   }
  # end

  # def self.standard_deck
  #   new_deck = self.new
  #   new_deck.add_modifier 'x0'
  #   new_deck.add_modifier '-2'
  #   new_deck.add_modifier '-1', 5
  #   new_deck.add_modifier '+0', 6
  #   new_deck.add_modifier '+1', 5
  #   new_deck.add_modifier '+2'
  #   new_deck.add_modifier 'x2'
  #   new_deck
  # end
end

# amd = AttackModifierDeck.new
# puts "Deck: #{amd.deck.inspect}"
# puts "Average: #{amd.average_damage}"
# amd.remove_modifier '-1', 5
# puts "Deck after removal: #{amd.deck.inspect}"
# puts "Average after removing -1 twice: #{amd.average_damage}"
# amd.shuffle
# puts "Shuffled: #{amd.deck.inspect}"
