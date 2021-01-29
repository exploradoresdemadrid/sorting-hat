require 'csv'

class Event < ApplicationRecord
  has_many :people, dependent: :destroy
  has_many :preferences, through: :people
  has_many :sessions, dependent: :destroy
  has_many :executions
  attr_accessor :import

  before_save :import_data

  private

  def import_data
    return unless import.is_a?(ActionDispatch::Http::UploadedFile)

    csv = CSV.read(import, headers: true)

    ActiveRecord::Base.transaction do
      clear_data
      session_names = csv.headers.compact
      session_names.each { |name| sessions.create(name: name) }

      people_names = csv.map { |row| row[0] }
      people_names.each { |name| people.create(name: name) }
    end
  end

  def clear_data
    sessions.delete_all
    people.delete_all
  end
end
