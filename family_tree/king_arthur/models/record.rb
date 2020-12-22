class Record
  @@all_records = Array.new

  def initialize
  end

  def save
    @@all_records << self
    true
  end

  def self.create(args)
    record = self.new(args)
    record.save
    record
  end

  def self.all
    @@all_records.find_all do |record|
      record.class.name == self.name
    end
  end

  def self.find(args)
    return nil unless args
    self.all.find do |record|
      # Checking for arguments which are satisfied
      condition = args.map do |key, val|
        record.send(key.to_sym) == val
      end.uniq
      return record if condition.all?
    end
  end

  def self.where(args)
    return nil unless args
    self.all.find_all do |record|
      # Checking for arguments which are satisfied
      condition = args.map do |key, val|
        record.send(key.to_sym) == val
      end.uniq
      record if condition.one?
    end
  end

  def self.find_or_create_by(args)
    record = self.find(args)
    unless record
      new_record = self.new(args)
      new_record.save
    end
    record || new_record
  end
end
