require 'csv'

class Event < ApplicationRecord
  has_many :people, dependent: :destroy
  has_many :preferences, through: :people
  has_many :sessions, dependent: :destroy
  has_many :executions, dependent: :destroy
  attr_accessor :import

  after_create :import_data

  private

  def import_data
    return unless import.is_a?(ActionDispatch::Http::UploadedFile)

    csv = CSV.read(import, headers: true)

    ActiveRecord::Base.transaction do
      clear_data

      new_sessions = csv.headers.compact.map { |name| sessions.create(name: name) }

      csv.each do |row|
        capture = row[0].match(/(?<name>.+)\s+\((?<group>.+)\)/)
        person = if capture
          people.create(name: capture[:name], group: capture[:group])
        else
          people.create(name: row[0])
        end

        row.to_h.select { |k, _v| k }.each do |session_name, value|
          person.preferences.create(session: new_sessions.find { |s| s.name == session_name }, value: value)
        end
      end
    end
  end

  def clear_data
    sessions.delete_all
    people.delete_all
  end
end
