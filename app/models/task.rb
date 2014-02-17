class Task < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user

  def format_date
    origin_date.to_date
  end
  def completed?

#    Github.ping(user.username)
#   return true if
  end
end
