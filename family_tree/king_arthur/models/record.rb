# frozen_string_literal: true

class Record
  @@all_records = []

  def initialize(*args); end

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

  def self.set_callbacks(record, args)
    record.send(:save_spouse, args[:partner]) if args[:partner]
  end

  def self.create!(args)
    argm = send(:attrs, args)
    record = find(argm)
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

  def save_spouse(spouse_name)
    spouse_member = self.class.find(name: spouse_name)
    return unless spouse_member

    spouse_member.partner = name
    spouse_member.save
  end

  def self.attrs(args)
    argm = args
    mother_name = args[:mother]
    argm[:parent_id] = find({ name: mother_name }).id if mother_name
    argm.reject { |key, _v| %w[id partner mother].include?(key.to_s) }
  end
end
