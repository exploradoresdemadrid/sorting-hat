class ExecutionJob < ApplicationJob
  queue_as :default

  def perform(execution_id)
    Rails.logger.info("Executing job for execution #{execution_id}")
    Execution.find(execution_id).in_progress!

    ExecutionService.new(execution_id).run
  rescue StandardError => e
    Execution.find(execution_id).error!
    raise e
  end
end
