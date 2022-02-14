module ExecutionsHelper
  def people_in_session(assignments)
    distribution = assignments.group_by { |a| a.preference.session }
    number_of_rows = distribution.values.map(&:size).max
    number_of_columns = distribution.keys.count

    distribution_array = distribution.to_a
    headers = content_tag(:th) do
      distribution.map { |session, people| content_tag(:td, "#{session.name} (#{people.count})") }.inject(:+)
    end

    body = (0...number_of_rows).map do |row|
      content_tag(:tr) do
        content_tag(:td) + (0...number_of_columns).map do |column|
          preference = distribution_array[column]&.last&.dig(row)&.preference
          person_name = preference&.person
          unhappiness = preference&.value.to_i - 1

          if unhappiness.positive?
            unhappiness_marker = " (-#{unhappiness})" if unhappiness.positive?
            content_tag(:td, content_tag(:strong, "#{person_name}#{unhappiness_marker}"))
          else
            content_tag(:td, person_name)
          end
        end.inject(:+)
      end
    end.inject(:+)

    content_tag(:table) do
      headers + body
    end
  end

  def distribution_by_group(assignments)


    distribution = assignments.joins(preference: [:person, :session])
                              .group('people.group', 'sessions.name')
                              .count
                              .map{|(group, session), count | {group => {session => count}}}
                              .inject(:deep_merge)

    session_names = assignments.first.execution.event.sessions.pluck(:name)

    content_tag(:table) do
      content_tag(:th) do
        session_names.map{ |name| content_tag(:td, name) }.inject(:+)
      end + 
      distribution.map do |group, sessions_count|
        content_tag(:tr) do
          content_tag(:td, group) +
          session_names.map{|session| content_tag(:td, sessions_count[session])}.inject(:+)
        end
      end.inject(:+)
    end
  end
end
