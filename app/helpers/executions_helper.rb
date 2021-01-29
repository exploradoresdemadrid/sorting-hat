module ExecutionsHelper
  def people_in_session(execution, session)
    Person.joins(preferences: :assignments).where(assignments: {execution_id: execution.id}, preferences: {session_id: session.id}).pluck(:name)
  end
end
