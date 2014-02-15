require 'spec_helper'

describe Task do
  describe 'associations' do

    context 'belongs to a user' do
      let(:user) { create :user }
      let(:task) { create :task, user: user }

      it 'returns the user' do
        expect(task.user).to eq user
      end
    end
  end

  describe 'validations' do

    context 'required attributes' do
      let(:task) { build :task }

      context 'given a user' do
        before { task.valid? }

        it 'is valid' do
          expect(task).to be_valid
        end
      end

      context 'given no user' do
        before { task.user = nil }
        before { task.valid? }

        it 'is not valid' do
          expect(task.errors.keys).to include(:user)
        end
      end
    end
  end
end
