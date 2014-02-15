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
end
