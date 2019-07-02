require_relative 'attack_modifier'

class AttackModifierDeck

  attr_accessor :deck
  attr_accessor :discard

  def initialize
    @deck = []
    @deck.push AttackModifier.new('RSx0')
    @deck.push AttackModifier.new('-2')
    5.times { @deck.push AttackModifier.new('-1') }
    6.times { @deck.push AttackModifier.new('+0') }
    5.times { @deck.push AttackModifier.new('+1') }
    @deck.push AttackModifier.new('+2')
    @deck.push AttackModifier.new('RSx2')
    @discard = []
  end

  def add_modifier(modifier)
    deck.push AttackModifier.new(modifier)
  end

  def remove_modifier(modifier)
    deck.slice!(deck.index(deck.select { |mod| mod.id == modifier }.first))
  end

  def shuffle
    deck.shuffle!
  end

  # def average_damage(base=3)
  #   sum = 0.0
  #   deck.each do |mod|
  #     case mod
  #     when 'x0'
  #       sum += base
  #     when '-2'
  #       sum += base-2
  #     when '-1'
  #       sum += base-1
  #     when '+0'
  #       sum += base
  #     when '+1'
  #       sum += base+1
  #     when '+2'
  #       sum += base+2
  #     when 'x2'
  #       sum += base*2
  #     end
  #   end
  #   sum / deck.length
  # end

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

  def reshuffle_in_discard?
    discard.select { |modifier| modifier.is_reshuffle? }.any?
  end

  def print(arg=nil)
    if arg == :discard
      discard.map { |modifier| modifier.id }.inspect
    else
      deck.map { |modifier| modifier.id }.inspect
    end
  end
end
