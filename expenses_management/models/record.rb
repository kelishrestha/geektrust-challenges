# frozen_string_literal: true

require 'pry'

# Base Record
class Record
  attr_accessor :id

  @@all_records = []

  def initialize(args, &block)
    args.each do |key, val|
      build(key, val, &block)
    end
  end

  def build(method_name, *args, &block)
    # Check if the method missing is an "attr=" method
    # raise unless method_name.to_s.end_with?("=")
    setter = method_name
    getter = method_name.to_s.to_sym
    instance_var = "@#{getter}".to_sym
    # Actually sets the value on the instance variable
    value = args.first
    instance_variable_set(instance_var, value)

    define_singleton_method(setter) do |new_val|
      instance_variable_set(instance_var, new_val)
    end
    define_singleton_method(getter) { instance_variable_get(instance_var) }
  rescue StandardError
    # Raise error as normal, nothing to see here
    super(method_name, *args, &block)
  end

  def save
    unless id
      send(:set_id)
      @@all_records << self
    end
    self
  end

  def self.create(args)
    create!(args)
  end

  def self.all
    @@all_records.find_all do |record|
      record.instance_of?(self)
    end
  end

  def self.find(args)
    return nil unless args || !args.values.compact.empty?

    all.find do |record|
      # Checking for arguments which are satisfied
      condition = args.map do |key, val|
        record.send(key.to_sym) == val
      end.uniq
      return record if condition.all?
    end
  end

  def self.where(args)
    return nil unless args || !args.values.compact.empty?

    all.find_all do |record|
      # Checking for arguments which are satisfied
      condition = args.map do |key, val|
        record.send(key.to_sym) == val
      end.uniq
      record if condition.all?
    end
  end

  def self.find_or_create_by(args)
    create!(args)
  end

  def self.delete_all
    @@all_records = []
  end

  def self.set_callbacks(record, args)
    # TODO: set callbacks
  end

  def self.create!(args)
    record = find(args)
    unless record
      record = new(args)
      record.save
    end
    set_callbacks(record, args)
    record
  end

  private

  def set_id
    self.id = self.class.all.length + 1
  end
end
