class Event < ApplicationRecord
  has_many :people, dependent: :destroy
  has_many :sessions, dependent: :destroy
end
