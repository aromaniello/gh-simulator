require_relative 'attack_modifier_deck'

module AMDGenerator
  def self.scoundrel_full
    deck = AttackModifierDeck.new
    deck.remove_modifier '-2'
    5.times { deck.remove_modifier '-1' }
    6.times { deck.remove_modifier '+0' }
    deck.add_modifier '+0'
    deck.add_modifier '+1'
    2.times { deck.add_modifier '+2' }
    4.times { deck.add_modifier 'RM+1' }
    2.times { deck.add_modifier 'RMPIERCE3' }
    4.times { deck.add_modifier 'RMPOISON' }
    2.times { deck.add_modifier 'RMMUDDLE' }
    deck.add_modifier 'RMINVIS'
    deck
  end

  def self.berserker_full
    deck = AttackModifierDeck.new
    4.times { deck.remove_modifier '-1' }
    6.times { deck.remove_modifier '+0' }
    2.times { deck.add_modifier '+1' }
    2.times { deck.add_modifier 'RM+2' }
    4.times { deck.add_modifier 'RMWOUND' }
    2.times { deck.add_modifier 'RMSTUN' }
    deck.add_modifier 'RM+1DISARM'
    2.times { deck.add_modifier 'RMHEAL1' }
    2.times { deck.add_modifier '+2FIRE' }
    deck
  end

  def self.spellweaver_full
    deck = AttackModifierDeck.new
    4.times { deck.remove_modifier '+0' }
    2.times { deck.remove_modifier '-1' }
    6.times { deck.add_modifier '+1' }
    deck.add_modifier '+0STUN'
    deck.add_modifier '+1WOUND'
    deck.add_modifier '+1IMMOB'
    deck.add_modifier '+1CURSE'
    2.times { deck.add_modifier '+2FIRE' }
    2.times { deck.add_modifier '+2ICE' }
    deck.add_modifier 'RMEARTH'
    deck.add_modifier 'RMWIND'
    deck.add_modifier 'RMLIGHT'
    deck.add_modifier 'RMDARK'
    deck
  end

  def self.spellweaver_no_rolling
    deck = AttackModifierDeck.new
    4.times { deck.remove_modifier '+0' }
    2.times { deck.remove_modifier '-1' }
    6.times { deck.add_modifier '+1' }
    deck.add_modifier '+0STUN'
    deck.add_modifier '+1WOUND'
    deck.add_modifier '+1IMMOB'
    deck.add_modifier '+1CURSE'
    2.times { deck.add_modifier '+2FIRE' }
    2.times { deck.add_modifier '+2ICE' }
    deck
  end
end
