# frozen_string_literal: true

require_relative './../../models/record'
require_relative './../../models/member_helper'
require_relative './../../models/member'

describe MemberHelper do
  let(:king_arthur) do
    Member.create(name: 'King Arther', gender: 'male', mother_name: nil, partner: 'Queen Margret')
  end
  let(:queen_margret) do
    Member.create(name: 'Queen Margret', gender: 'female', mother_name: nil, partner: 'King Arther')
  end
  let(:bill) do
    Member.create(name: 'Bill', gender: 'male', mother_name: 'Queen Margret')
  end
  let(:flora) do
    Member.create(name: 'Flora', gender: 'female', mother_name: nil, partner: 'Bill')
  end
  let(:percy) do
    Member.create(name: 'Percy', gender: 'male', mother_name: 'Queen Margret')
  end
  let(:ginerva) do
    Member.create(name: 'Ginerva', gender: 'female', mother_name: 'Queen Margret')
  end
  let(:loius) do
    Member.create(name: 'Louis', gender: 'male', mother_name: 'Flora')
  end
  let(:victorie) do
    Member.create(name: 'Victorie', gender: 'female', mother_name: 'Flora')
  end

  before do
    king_arthur
    queen_margret
    bill
    flora
    percy
    ginerva
    loius
    victorie
  end

  shared_examples 'returns relational record' do |example|
    let(:result) {}

    it example.to_s do
      expect(subject).to eq(result)
    end
  end

  describe '#find_member_based_on_gender' do
    subject(:find_member_based_on_gender) do
      described_class.find_member_based_on_gender(records, type)
    end

    let(:records) do
      [bill, percy, ginerva]
    end

    context 'when type is male' do
      let(:type) { 'male' }

      include_examples 'returns relational record',
                       'returns all matching members with the gender criteria' do
        let(:result) { [bill, percy] }
      end
    end

    context 'when type is female' do
      let(:type) { 'female' }

      include_examples 'returns relational record',
                       'returns all matching members with the gender criteria' do
        let(:result) { [ginerva] }
      end
    end
  end

  describe '#find_member_based_on_spouse_gender' do
    subject(:find_member_based_on_spouse_gender) do
      described_class.find_member_based_on_spouse_gender(records, type)
    end

    let(:records) do
      [bill, percy, ginerva]
    end

    context 'when type is male' do
      let(:type) { 'male' }

      include_examples 'returns relational record',
                       'returns all matching members with the gender criteria' do
        let(:result) { [] }
      end
    end

    context 'when type is female' do
      let(:type) { 'female' }

      include_examples 'returns relational record',
                       'returns all matching members with the gender criteria' do
        let(:result) { [flora] }
      end
    end
  end

  describe '#member_siblings' do
    subject(:member_siblings) { described_class.member_siblings(member) }

    let(:member) { bill }

    include_examples 'returns relational record',
                     'returns all the siblings of the member' do
      let(:result) { [percy, ginerva] }
    end
  end

  describe '#fetch_relations' do
    subject(:fetch_relations) { described_class.fetch_relations(member, type, relation) }

    let(:member) {}
    let(:type) {}
    let(:relation) {}

    context 'when type is in_laws' do
      let(:type) { 'in_laws' }

      context 'with relation as father' do
        let(:relation) { 'father' }
        let(:member) { flora }

        include_examples 'returns relational record',
                         'returns all the siblings of the member' do
          let(:result) { king_arthur }
        end
      end

      context 'with relation as mother' do
        let(:relation) { 'mother' }
      end

      context 'with relation as sister' do
        let(:relation) { 'sister' }
      end

      context 'with relation as brother' do
        let(:relation) { 'brother' }
      end

      context 'with relation as daughter' do
        let(:relation) { 'daughter' }
      end

      context 'with relation as son' do
        let(:relation) { 'son' }
      end
    end

    context 'when type is uncle_or_aunt' do
      let(:type) { 'uncle_or_aunt' }
    end

    context 'when type is children' do
      let(:type) { 'children' }
    end
  end
end
