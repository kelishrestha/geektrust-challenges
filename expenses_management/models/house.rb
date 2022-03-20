# frozen_string_literal: true

require_relative './record'
require_relative './../constants'

# House Record
class House < Record
  attr_accessor :id, :member, :due_amount

  def initialize(args)
    super
  end

  def self.add_members(args)
    return Message::INSUFFICIENT_PARAMS if args.empty?
    return Message::HOUSEFUL if self.all.count == 3
    self.find_or_create_by(args)
    return Message::SUCCESS
  end
end
