require 'spec_helper'

describe User do
  describe 'associations' do
    context 'has many tasks' do
      let(:user) { create :user }
      let(:tasks) { create_list :task, 3, user: user }

      it 'returns the tasks' do
        expect(user.tasks).to eq tasks
      end
    end
  end

  describe 'validations' do
    context 'required attributes' do
      let(:user) { build :user }

      context 'given a github username' do
        before { user.valid? }

        it 'is valid' do
          expect(user).to be_valid
        end
      end

      context 'given no github username' do
        before { user.github_username = nil }
        before { user.valid? }

        it 'is not valid' do
          expect(user.errors.keys).to include(:github_username)
        end
      end
    end

    context 'uniqueness' do
      let(:user) { create :user, github_username: 'bomatson' }

      context 'given a duplicate github username' do
        let(:duplicate) { build :user, github_username: 'bomatson' }

        before { expect(user).to be }
        before { duplicate.valid? }

        it 'is invalid' do
          expect(duplicate.errors.keys).to include(:github_username)
        end
      end
    end
  end
end
