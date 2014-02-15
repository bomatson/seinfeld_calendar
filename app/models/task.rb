class Task < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user

  def completed?

#    Github.ping(user.username)
#   return true if
  end
end
