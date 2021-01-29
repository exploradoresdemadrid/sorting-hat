class Execution < ApplicationRecord
  belongs_to :event
  has_many :assignments, dependent: :destroy
  after_create :spawn_job
  enum status: {
    unstarted: 0,
    in_progress: 1,
    succeeded: 2,
    error: 3,
    paused: 4,
    stopped: 5
  }

  def formatted_progress
    "#{(100 * progress.to_f).round}%"
  end

  private

  def spawn_job
    ExecutionJob.perform_later(id)
  end
end
