class Person < ApplicationRecord
  belongs_to :event
  has_many :preferences, dependent: :destroy

  def to_s
    "#{name} (#{group}) "
  end
end
