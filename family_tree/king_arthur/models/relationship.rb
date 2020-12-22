class Relationship < Record
  attr_accessor :member_1, :member_2, :relation

  def initialize(args)
    @member_1 = args[:member_1]
    @member_2 = args[:member_2]
    @relation = args[:relation]
  end

  def self.find_relationship(args)
    self.all.find do |relationship|
      member_1_name = relationship.member_1
      member_2_name = relationship.member_2
      if (is_member_name?(member_1_name, args[:name]) || is_member_name?(member_2_name, args[:name])) && relationship.relation == args[:relation]
        member = if is_member_name?(member_1_name, args[:name])
          find_member(member_1_name)
        else
          find_member(member_2_name)
        end
        return member
      end
    end
  end

  private

  def self.is_member_name?(member_name, name)
    find_member(member_name)
    member.name == name
  end

  def find_member(member_name)
    return member_name unless member_name.is_a? String
    Member.find(name: member_name)
  end
end
