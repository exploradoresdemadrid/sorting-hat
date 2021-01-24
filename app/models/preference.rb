class Preference < ApplicationRecord
  belongs_to :person
  belongs_to :session
end
