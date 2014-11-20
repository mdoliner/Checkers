class EmptySpace < NilClass

  def self.nil?
    true
  end

  def self.to_s
    " "
  end

  def self.is_enemy?(color)
    false
  end

  def self.color
    nil
  end

end
