class Member < Record
  attr_accessor :name, :gender, :spouse, :mother, :spouse

  @@all_records = Array.new

  def initialize(args)
    @name = args[:name]
    @gender = args[:gender]
    @mother = args[:mother]
    @spouse = args[:spouse]
  end

  def save
    create_relationships
    super
  end

  def relation(name)
    send("#{name}_relation".to_sym, self)
  end

  private

  def create_relationships
    create_spouse_relationship unless self.spouse.to_s.empty?
    create_parent_relationships unless self.mother.to_s.empty?
  end

  def create_spouse_relationship
    Relationship.find_or_create_by(member_1: self.name, member_2: self.spouse, relation: 'spouse')
  end

  def create_parent_relationships
    mother = Member.find(name: self.mother)
    father = mother.relation('spouse')
    Relationship.create(member_1: self.name, member_2: mother.name, relation: 'mother')
    Relationship.create(member_1: self.name, member_2: father.name, relation: 'father')
  end

  def alternate_gender(gender)
    %w[male female] - [gender]
  end

  def spouse_relation(member)
    Member.find(name: member.spouse, spouse: member.name)
  end
end

king_arthur = Member.new(name: 'King Arther', gender: 'male', mother: nil, spouse: 'Queen Margret')
king_arthur.save
queen = Member.new({ name: 'Queen Margret', gender: 'female', mother: nil, spouse: 'King Arther' })
queen.save
Member.all
Relationship.all

bill = Member.new({ name: 'Bill', gender: 'male', mother: 'Queen Margret', spouse: nil })
bill.save
Relationship.find(member_1: 'Bill', relation: 'father')
Relationship.find_relationship(name: 'Bill', relation: 'spouse')
# member = Member.create({ name: 'Flora', gender: 'male', mother: nil, spouse: 'Bill' })
