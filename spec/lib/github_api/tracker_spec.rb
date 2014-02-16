require 'spec_helper'
require "#{Rails.root}/lib/github_api/tracker"

describe Tracker do

  describe '#run!' do
    let(:tracker) { Tracker.new(user) }

    subject { tracker.run! }

    context 'given a user with tasks' do
      let(:user) { create :user }
      let(:last_modified_task) do
        create :task,
          updated_at: 1.day.ago,
          user: user
      end
      let(:tasks) do
        create_list :task, 3,
          updated_at: 3.days.ago,
          user: user
      end

      before do
        expect(last_modified_task).to be
        expect(tasks).to be
        stub_request(:get,
                     "https://api.github.com/user/repos")
          .to_return(status: 200, body: repo_with_commits.to_json)
      end

      context 'given they have an updated repo' do
        let(:repo_with_commits) {[
          {
          name: 'Autotune',
          updated_at: 2.hours.ago,
        },{ name: 'something', updated_at: 1.day.ago}]}

        before do
        end

        it 'creates a new task for each seinfeld commit' do
          expect(subject).to eq 1
        end
      end

      context 'given they have no updated repo' do
        let(:repo_with_commits) {{
          name: 'Autotune',
          updated_at: 2.days.ago,
        }}

        it 'does not create a new task' do
        end
      end
    end

    context 'given a user without tasks' do

    end
  end
end
