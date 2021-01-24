class Person < ApplicationRecord
  belongs_to :event
  has_many :preferences
end
