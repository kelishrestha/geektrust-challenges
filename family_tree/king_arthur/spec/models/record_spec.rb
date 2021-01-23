# frozen_string_literal: true

require_relative './../../models/record'

describe Record do
  let(:chunchun) { Record.create(name: 'chunchun') }
  let(:kelina) { Record.create(name: 'kelina') }
  let(:suzume) { Record.create(name: 'suzume') }

  before do
    chunchun
    kelina
    suzume
  end

  describe '#save' do
    subject(:save_record) { record.save }

    let(:record) { Record.new(name: 'Kelina Shrestha') }

    it 'saves the record' do
      expect { save_record }.to change { Record.all.count }.by(1)
    end
  end

  describe '#create' do
    subject(:create_record) { described_class.create(args) }

    let(:args) do
      { name: 'Suzume Yosano' }
    end

    it 'creates the record' do
      expect { create_record }.to change { Record.all.count }.by(1)
    end
  end

  describe '#all' do
    subject(:all_records) { described_class.all }

    it 'lists all the records' do
      expect(all_records).to include(chunchun, kelina, suzume)
    end
  end

  describe '#where' do
    subject(:where_query) { described_class.where(name: 'kelina') }

    it 'lists all the matching records' do
      expect(where_query).to eq([kelina])
    end
  end

  describe '#find' do
    subject(:find_query) { described_class.find(name: 'kelina') }

    it 'find matching records' do
      expect(find_query).to eq(kelina)
    end
  end

  describe '#find_or_create_by' do
    subject(:find_or_create_by_query) { described_class.find_or_create_by(args) }

    let(:args) do
      {
        name: 'kelina'
      }
    end

    context 'when record already exists' do
      it 'find matching records' do
        expect(find_or_create_by_query).to eq(kelina)
      end

      it 'does not create new record' do
        expect { find_or_create_by_query }.to change { Record.all.count }.by(0)
      end
    end

    context 'when record does not exist' do
      let(:args) do
        {
          name: 'yosano'
        }
      end

      it 'creates new record' do
        expect { find_or_create_by_query }.to change { Record.all.count }.by(1)
      end
    end
  end

  describe '#delete_all' do
    subject(:delete_all_records) { described_class.delete_all }

    it 'deletes all records' do
      subject
      expect(described_class.all.count).to eq(0)
    end
  end
end
