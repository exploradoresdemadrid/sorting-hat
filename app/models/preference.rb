class Preference < ApplicationRecord
  belongs_to :person
  belongs_to :session
  has_many :assignments, dependent: :destroy
end
