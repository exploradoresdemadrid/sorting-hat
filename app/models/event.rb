class Event < ApplicationRecord
  has_many :people, dependent: :destroy
  has_many :preferences, through: :people
  has_many :sessions, dependent: :destroy
  has_many :executions
end
