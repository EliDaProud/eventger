class Event < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  validates :title, :description, :start_time, :end_time, presence: true
end
