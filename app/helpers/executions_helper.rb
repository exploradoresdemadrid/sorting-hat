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
          content_tag(:td, distribution_array[column]&.last[row]&.preference&.person&.name)
        end.inject(:+)
      end
    end.inject(:+)

    content_tag(:table) do
      headers + body
    end
  end
end
