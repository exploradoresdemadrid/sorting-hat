class ExecutionsController < ApplicationController
  before_action :set_execution, only: %w[show create]

  def show
    @assignments = @execution.assignments.includes(preference: %i[person session])
  end

  def create
    params.require(:execution).permit(:amount)[:amount].to_i.times do
      @event.executions.create
    end
    redirect_to event_url(@event)
  end

  private

  def set_execution
    @event = Event.find(params[:event_id])
    @execution = @event.executions.find_by(id: params[:id])
  end
end
