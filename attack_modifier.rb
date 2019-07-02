class AttackModifier
  attr_accessor :id

  def initialize(id)
    @id = id
  end

  def is_reshuffle?
    id.include? 'RS'
  end

  def is_rolling?
    id.include? 'RM'
  end

  def is_terminal?
    !is_rolling?
  end

  def attack_value(base=nil)
    if is_rolling?
      if id.include? '+1'
        1
      elsif id.include? '+2'
        2
      else
        0
      end
    else # not rolling
      if id.include? 'x0'
        0
      elsif id.include? '-2'
        base-2
      elsif id.include? '-1'
        base-1
      elsif id.include? '+0'
        base
      elsif id.include? '+1'
        base+1
      elsif id.include? '+2'
        base+2
      elsif id.include? 'x2'
        base*2
      end
    end
  end

  # integrate into attack value
  # def rolling_attack_value
  #   if is_rolling? && id.include? '+1'
  #     1
  #   elsif is_rolling? && id.include? '+2'
  #     2
  #   else
  #     0
  #   end
  # end
end
