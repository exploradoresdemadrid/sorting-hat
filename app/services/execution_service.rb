class ExecutionService
  attr_reader :execution

  def initialize(execution_id)
    @execution = Execution.find(execution_id)
  end

  def run
    event = execution.event

    people = event.people.order(created_at: :asc).pluck :name
    sessions = event.sessions.order(created_at: :asc).pluck :name
    preferences = event.preferences.pluck(:person_id, :value).group_by(&:first).map { |_k, v| v.map(&:last) }

    vns = VNS::VNS.new(people, sessions, preferences) do |progress, target_function|
      puts "progress = #{progress}, target_funcion = #{target_function}"
      execution.update(progress: progress, target_function: target_function)
    end
    vns.run
    execution.succeeded!
    Rails.logger.info "Target funcion: #{vns.target_function}"
  end
end
