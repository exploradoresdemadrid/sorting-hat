class ExecutionsController < ApplicationController
  before_action :set_execution, only: %w[ show edit update destroy ]

  def show
  end

  private

  def set_execution
    @event = Event.find(params[:event_id])
    @execution = @event.executions.find_by(id: params[:id])
  end
end
