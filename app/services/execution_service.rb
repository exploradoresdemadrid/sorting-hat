class ExecutionService
  attr_reader :execution, :event, :people, :sessions, :preferences

  def initialize(execution_id)
    @execution = Execution.find(execution_id)
    @event = execution.event

    @people = event.people.order(created_at: :asc)
    @sessions = event.sessions.order(created_at: :asc)
    @raw_preferences = event.preferences
    @preferences = @raw_preferences.pluck(:person_id, :value).group_by(&:first).map { |_k, v| v.map(&:last) }
  end

  def run
    vns = VNS::VNS.new(people.pluck(:id), sessions.pluck(:id), preferences) do |progress, target_function, solution|
      puts "progress = #{progress}, target_funcion = #{target_function}"
      execution.update(progress: progress, target_function: target_function)
      presist_solution(solution)
    end
    vns.run
    execution.succeeded!
    Rails.logger.info "Target funcion: #{vns.target_function}"
  end

  private

  def presist_solution(solution)
    ActiveRecord::Base.transaction do
      execution.assignments.delete_all
      solution.each do |sol_session, sol_people|
        sol_people.each do |sol_person|
          preference_assigned = @raw_preferences.find { |p| p.session_id == sol_session && p.person_id == sol_person }
          execution.assignments.create!(preference: preference_assigned)
        end
      end
    end
  end
end
