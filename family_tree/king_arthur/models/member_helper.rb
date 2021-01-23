# frozen_string_literal: true

# Helper methods for member record
module MemberHelper
  class << self
    def find_member_based_on_gender(records, type)
      records.select { |record| record if record.gender == type.to_s }
    end

    def find_member_based_on_spouse_gender(records, type)
      records.map do |child|
        spouse = child.send(:spouse)
        spouse if spouse&.gender == type
      end.compact
    end

    def alternate_gender(gend)
      %w[male female] - [gend]
    end

    def member_siblings(member)
      member.send(:siblings)
    end

    def fetch_relations(member, type, relation)
      case type
      when 'in_laws'
        spouse_member = member.send(:spouse)
        case relation
        when 'father'
          spouse_member.send(:father)
        when 'mother'
          spouse_member.send(:mother)
        when 'sister', 'sisters'
          (find_member_based_on_gender(member_siblings(spouse_member), 'female') +
          find_member_based_on_gender(siblings, 'female')).compact
        when 'brother', 'brothers'
          (find_member_based_on_gender(member_siblings(spouse_member), 'male') +
          find_member_based_on_gender(siblings, 'male')).compact
        when 'daughter', 'daughters'
          find_member_based_on_spouse_gender(children, 'female').compact
        when 'son', 'sons'
          find_member_based_on_spouse_gender(children, 'male').compact
        end
      when 'uncle_or_aunt'
        case relation
        when 'uncle', 'uncles'
          find_member_based_on_gender(member_siblings(member), 'male')
        when 'aunt', 'aunts'
          find_member_based_on_gender(member_siblings(member), 'female')
        else
          member.send(:all_siblings).compact
        end
      when 'children'
        case relation
        when 'sons', 'son'
          find_member_based_on_gender(member, 'male')
        when 'daughters', 'daughter'
          find_member_based_on_gender(member, 'female')
        else
          member
        end
      end
    end
  end
end
