class Event < ActiveRecord::Base
  belongs_to :author, class_name: :User, foreign_key: "user_id"
  has_many :comments

  validates :title, :description, :start_time, :end_time, presence: true
end
