class User < ActiveRecord::Base
  has_many :created_events, class_name: "Event", foreign_key: "author_id"
  has_many :comments
  has_one :authorization, dependent: :nullify
  has_and_belongs_to_many :events
end
