# frozen_string_literal: true

require_relative './../../models/record'
require_relative './../../models/member_helper'
require_relative './../../models/member'

describe Member do
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

  shared_examples 'Error message' do |message|
    it "returns error message as #{message}" do
      expect(subject).to eq(message)
    end
  end

  shared_examples 'add record' do |message|
    it message.to_s do
      expect { subject }.to change { Member.all.count }.by(1)
    end
  end

  shared_examples 'check attributes' do |message, attr_val|
    let(:attr) {}

    it message.to_s do
      expect(attr).to eq(attr_val)
    end
  end

  describe '.add_child' do
    subject(:add_child) { member.add_child(args) }

    let(:member) { ginerva }
    let(:args) { {} }

    context 'when arguments are not supplied' do
      include_examples 'Error message', 'INSUFFICIENT_PARAMS'
    end

    context 'when arguments are supplied' do
      let(:args) do
        {
          name: 'Suzume',
          gender: 'female'
        }
      end

      context 'when member is a female' do
        include_examples 'add record', 'add child to the member specified'

        it 'relates member with children' do
          expect(member.send(:children).map(&:name)).to include('Suzume')
        end
      end

      context 'when member is other than female' do
        let(:member) { bill }

        include_examples 'Error message', 'CHILD_ADDITION_FAILED'
      end
    end
  end

  describe '.add_spouse' do
    subject(:add_spouse) { member.add_spouse(member_name, member_gender) }

    let(:member_name) { 'Nancy' }
    let(:member_gender) {}
    let(:member) { percy }

    include_examples 'add record', 'add spouse to the member specified'

    include_examples 'check attributes', 'relates member with spouse', 'Nancy' do
      let(:attr) { member.send(:spouse).name }
    end
  end

  describe '#get_relationship' do
    subject(:get_relationship) { Member.get_relationship(member_name, relation_name) }

    let(:member_name) { 'Louis' }
    let(:relation_name) { 'father' }

    context 'when relationship exists' do
      it 'returns related member name' do
        expect(get_relationship).to eq('Bill')
      end
    end

    context 'when relationship does not exist' do
      let(:relation_name) { 'children' }

      include_examples 'Error message', 'NONE'
    end

    context 'when member does not exist' do
      let(:member_name) { 'Yosano' }

      include_examples 'Error message', 'PERSON_NOT_FOUND'
    end
  end
end
