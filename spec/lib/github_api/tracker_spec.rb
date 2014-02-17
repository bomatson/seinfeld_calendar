require 'spec_helper'
require "#{Rails.root}/lib/github_api/tracker"

describe Tracker do

  describe '#run!' do
    let(:tracker) { Tracker.new(user) }
    let(:user) { create :user }

    subject { tracker.run! }

    before do
      stub_request(:get,
                   "https://api.github.com/user/repos")
      .to_return(status: 200, body: repos_with_commits.to_json)

      stub_request(:get,
                   "https://api.github.com/repos/#{user.github_username}/#{updated_repo[:name]}/commits")
      .to_return(status: 200, body: commits.to_json)
    end

    context 'given a user with tasks' do
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
      end

      context 'given they have an updated repo' do
        let(:repos_with_commits) {[
        updated_repo, { name: 'something',
          updated_at: 3.days.ago}
        ]}
        let(:updated_repo) {{
          name: 'Autotune',
          updated_at: 2.hours.ago,
        }}

        context 'given it has a single seinfeld commit' do
          let(:commits) {[
            {author: { date: 3.days.ago }, message: 'something'},
            updated_commit,
          ]}
          let(:updated_commit) {
            {author: { date: 1.hour.ago }, message: 'seinfeld'}
          }

          it 'creates a 1 new task' do
            expect{ subject }.to change{ Task.count }.by(1)
          end
        end

        context 'given it has two seinfeld commits, but one old one' do
          let(:commits) {[
            {author: { date: 3.days.ago }, message: 'seinfeld'},
            updated_commit,
          ]}
          let(:updated_commit) {
            {author: { date: 1.hour.ago }, message: 'seinfeld'}
          }

          it 'creates a 1 new task' do
            expect{ subject }.to change{ Task.count }.by(1)
          end
        end

        context 'given it has two seinfeld commits' do
          let(:commits) {[
            {author: { date: 2.hours.ago }, message: 'seinfeld'},
            updated_commit,
          ]}
          let(:updated_commit) {
            {author: { date: 1.hour.ago }, message: 'seinfeld'}
          }

          it 'creates two new tasks' do
            expect{ subject }.to change{ Task.count }.by(2)
          end
        end

      end

      context 'given they have no updated repo' do
        let(:repos_with_commits) {[
          updated_repo
        ]}
        let(:updated_repo) {{
          name: 'Autotune',
          updated_at: 2.days.ago,}}
        let(:commits) { {} }

        it 'does not create a new task' do
          expect{ subject }.to_not change{ Task.count }
        end
      end
    end

    context 'given a user without tasks' do

      context 'with an updated repo' do
        let(:repos_with_commits) {[
          updated_repo,
        ]}
        let(:updated_repo) {{
          name: 'Rspec',
          updated_at: 2.hours.ago,
        }}

        context 'but no seinfeld commits' do
          let(:commits) {[
            {author: { date: 3.days.ago }, message: 'something'},
            updated_commit,
          ]}
          let(:updated_commit) {
            {author: { date: 1.hour.ago }, message: 'something else'}
          }

          it 'does not create a new task' do
            expect{ subject }.to_not change{ Task.count }
          end
        end

        context 'but 1 seinfeld commit' do
          let(:commits) {[
            {author: { date: 3.days.ago }, message: 'something'},
            updated_commit,
          ]}
          let(:updated_commit) {
            {author: { date: 1.hour.ago }, message: 'seinfeld'}
          }

          it 'creates a new task' do
            expect{ subject }.to change{ Task.count }.by(1)
          end
        end

        context 'but mutiple seinfeld commits' do
          let(:commits) {[
            {author: { date: 3.days.ago }, message: 'seinfeld'},
            updated_commit,
          ]}
          let(:updated_commit) {
            {author: { date: 1.hour.ago }, message: 'seinfeld'}
          }

          it 'creates multiple new tasks' do
            expect{ subject }.to change{ Task.count }.by(2)
          end
        end
      end

      context 'given they have no updated repo' do
        let(:repos_with_commits) {[
          updated_repo
        ]}
        let(:updated_repo) {{
          name: 'Autotune',
          updated_at: 2.days.ago,}}
        let(:commits) { {} }

        it 'does not create a new task' do
          expect{ subject }.to_not change{ Task.count }
        end
      end
    end
  end
end
