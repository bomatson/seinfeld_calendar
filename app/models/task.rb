class Task < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user

  def format_date
    origin_date.to_date
  end
end
