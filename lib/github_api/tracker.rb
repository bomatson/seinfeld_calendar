class Tracker
  def initialize(user)
    @user = user
    @date = latest_modification
  end

  def run!
    github = Github.new
    fetch_commits_from(github)
  end

  private

  def latest_modification
    if @user.tasks.present?
      latest_task = @user.tasks.order(updated_at: :desc).first
      latest_task.updated_at
    end
  end

  def fetch_commits_from(github)
    repos = github.repos.list user: @user.github_username

    repos_to_update = check_for_updates_on repos
    return if repos_to_update.empty?

    commits = repos_to_update.map do |repo|
      build_seinfeld_tasks_for(repo, github)
    end
  end

  def check_for_updates_on(repos)
    return repos if @date.nil?

    updates = repos.select do |repo|
      repo.updated_at > @date
    end
  end

  def build_seinfeld_tasks_for(repo, github)
    repo_name = repo[:name]
    commits = github.repos.commits.all @user.github_username, repo_name

    commits.each do |commit|
      commit_date = commit.commit.author.date
      if commit.commit.message.include?('seinfeld')
        if @date.present? && commit_date > @date
          create_task_for(commit_date)
        elsif @date.nil?
          create_task_for(commit_date)
        end
      end
    end
  end

  def create_task_for(commit_date)
    Task.create(origin_date: commit_date, user: @user)
  end
end
