require_relative '../base/base'

# Handles creation of player instance
class Player < Base
  attr_accessor :name,
                :color,
                :active,
                :check

  def initialize(name, color, active = false, check = false)
    @name = name
    @color = color
    @active = active
    @check = check
  end

  def self.active_user
    ObjectSpace.each_object(self) do |player|
      return player if player.active
    end
  end

  def self.active_user_name
    ObjectSpace.each_object(self) do |player|
      return player.name if player.active
    end
  end

  def self.inactive_user
    ObjectSpace.each_object(self) do |player|
      return player unless player.active
    end
  end

  def self.inactive_user_name
    ObjectSpace.each_object(self) do |player|
      return player.name unless player.active
    end
  end
end
