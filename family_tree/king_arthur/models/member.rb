# frozen_string_literal: true

require './family_tree/king_arthur/models/record'
require './family_tree/king_arthur/models/member_helper'

class Member < Record
  include MemberHelper
  attr_accessor :id, :name, :gender, :partner, :parent_id

  @@all_records = []

  def initialize(args)
    @name = args[:name]
    @gender = args[:gender]
    mother_name = args[:mother]
    @parent_id = mother_name ? Member.find(name: mother_name).id : nil
    @partner = args[:partner]
  end

  def self.get_relationship(member_name, relation_name)
    member = Member.find(name: member_name)
    return Message::PERSON_NOT_FOUND unless member

    method_name = relation_name.to_s.downcase.gsub(' ', '_').to_s
    results = member.send(method_name.to_sym)
    # TODO: Fix me with appropriate message
    return Message::NONE unless results

    results.is_a?(Array) ? results.map(&:name) : results.name
  end

  def add_child(args)
    return Message::PERSON_NOT_FOUND unless self

    if is_female?
      argm = args.merge(parent_id: id)
      self.class.find_or_create_by(argm)
      Message::CHILD_ADDITION_SUCCEEDED
    else
      Message::CHILD_ADDITION_FAILED
    end
  end

  def add_spouse(member_name, m_gender = nil)
    return Message::PERSON_NOT_FOUND unless self

    args = { name: member_name, partner: name }
    gend = m_gender || MemberHelper.alternate_gender(m_gender)
    args.merge!(gender: gend)
    self.class.find_or_create_by(args)
  end

  %w[male female].each do |gen|
    define_method("is_#{gen}?") do
      gender == gen
    end
  end

  Relation.constants.map(&:downcase).each do |relationship|
    relationship = relationship.to_s
    define_method(relationship.downcase) do
      if %w[uncle aunt].include? relationship
        tree, relation = relationship.split('_')
        uncles_or_aunts(tree, relation)
      elsif %w[in_law].include? relationship
        relation = relationship.split('_in_law')
        in_laws(relation[0])
      elsif %w[son daughter].include? relationship
        children(relationship)
      else
        relationship
      end
    end
  end

  private

  def spouse
    Member.find(name: partner, partner: name)
  end

  def mother
    Member.find(id: parent_id)
  end

  def father
    mother.spouse
  end

  def parents
    return unless parent_id

    [father, mother]
  end

  def siblings
    return unless mother

    Member.where(parent_id: mother.id) - [self]
  end

  def all_siblings
    mother.spouse.siblings + siblings
  end

  def children(relation = '')
    member_mother = gender == 'male' ? spouse : self
    return unless member_mother

    all_children = Member.where(parent_id: member_mother.id)
    MemberHelper.fetch_relations(all_children, 'children', relation)
  end

  def uncles_or_aunts(tree = '', relation = '')
    member_person = case tree
                    when 'maternal'
                      mother
                    when 'paternal'
                      father
                    else
                      parents
                    end

    return unless member_person

    MemberHelper.fetch_relations(member_person, 'uncle_or_aunt', relation)
  end

  def in_laws(relation)
    MemberHelper.fetch_relations(self, 'in_laws', relation)
  end
end
