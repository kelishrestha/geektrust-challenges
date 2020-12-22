class Relation < Record
  attr_accessor :relation

  def initialize(relation)
    @relation = relation
  end
end
