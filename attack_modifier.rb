class AttackModifier
  attr_accessor :id

  def initialize(id)
    @id = id
  end

  def is_rolling?
    id.include? 'RM'
  end
end
