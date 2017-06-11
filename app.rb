require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require './models/subtopic'
require './models/listen'
require './models/recommendation'
require './lib/setup.rb'

populate_subtopics
populate_recommendations

get '/recommendations' do
  subtopic_uuid = params['subtopic']
  return [400, {}, ['No subtopic uuid was specified.']] if subtopic_uuid.nil? || subtopic_uuid.empty?
  return [404, {}, ['No subtopic exists for that uuid.']] if not subtopic = Subtopic.find_by_uuid(subtopic_uuid)
  Recommendation.find_by_subtopic_id(subtopic.id).to_json
end
