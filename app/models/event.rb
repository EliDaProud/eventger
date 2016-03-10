class Event < ActiveRecord::Base
  belongs_to :author, class_name: :User, foreign_key: "author_id"
  has_many :comments
  has_and_belongs_to_many :users

  validates :title, :description, :start_time, :end_time, presence: true
end
