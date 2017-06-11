class Recommendation < ActiveRecord::Base
  belongs_to :subtopic

  def to_json
    {
      subtopic: subtopic.uuid,
      recommendations: recommendation_uuids
    }.to_json
  end

  def recommendation_uuids
    [first, second, third, fourth].compact
  end
end
