class User < ActiveRecord::Base
  has_many :events
  has_many :comments
  has_one :authorization, dependent: :nullify
end
