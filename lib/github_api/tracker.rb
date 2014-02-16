class Tracker
  def initialize(user)
    @user = user
    @date = lastest_modification
  end

  def run!
    github = Github.new
    repos = fetch_commits_for(github)
    build_seinfeld_tasks_for(repos, @date)
    #user.last_task_modified = DateTime.now
  end

  private

  def lastest_modification
    if @user.tasks.present?
      latest_task = @user.tasks.order(updated_at: :desc).first
      latest_task.updated_at
    else
      DateTime.now
    end
  end

  def fetch_commits_for(github)
    repos = github.repos.list @user.github_username
    return if check_for_updates_on(repos).empty?
    commits = repos.map do |repo|

    end

  end

  def build_seinfeld_tasks_for(repos, date)
    repos.each do |repo|

    end
    #iterate over all repo commits
    #create task for each date where a commit says seinfeld
  end

  def check_for_updates_on(repos)
    binding.pry
    repos.map(&:updated_at).select do |date|
      date > @date
    end
  end

end
