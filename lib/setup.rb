require 'matrix'
require 'tf-idf-similarity'

SEMANTIC_SIMILARITY_THRESHOLD = 0.3 # Lean towards a liberal threshold to allow for more recommendations

def populate_subtopics
  # cheap check so we don't attempt to re-seed the db
  return if Subtopic.count > 160

  ActiveSupport::JSON.decode(File.read('./subtopics.json')).each do |params|
    uuid = params['id'] || params['uuid']
    name = params['name']
    description = params['description']

    Subtopic.create! uuid: uuid,
                     name: name,
                     description: description
  end
end

def populate_listens
  return if Listen.count >= 252886

  ActiveSupport::JSON.decode(File.read('./listens.json')).each do |params|
    subtopic_uuid = params['subtopic']
    subtopic_id = Subtopic.find_by_uuid(subtopic_uuid).id
    listen_date = params['listenDate']
    user = params['user']

    Listen.create! subtopic_id: subtopic_id,
                   subtopic_uuid: subtopic_uuid,
                   listen_date: listen_date,
                   user: user
  end
end

def populate_recommendations
  return if Recommendation.count > 160
  # Generate a matrix of Term Frequency-Inverse Document Frequency (tf-idf) weights,
  # based on the names + descriptions of the subtopics
  # For two subtopics i and j, their semantic similarity score (between 0 and 1) is matrix[i, j]
  descriptions = Subtopic.pluck(:name, :description).map { |s| s.join(' ') }
  corpus = descriptions.map { |description| TfIdfSimilarity::Document.new(description) }
  model = TfIdfSimilarity::TfIdfModel.new(corpus)
  similarity_matrix = model.similarity_matrix

  (0...corpus.length).each do |subtopic_id|
    # Fetch the ids of the 4 most similar subtopics that are similar enough (exclude the subtopic itself)

    similarity_to_id = {}
    similarity_matrix.row(subtopic_id).each_with_index do |similarity, similar_subtopic_id|
      next if subtopic_id == similar_subtopic_id
      similarity_to_id[similarity] = similar_subtopic_id
    end

    similar_subtopic_ids = similarity_to_id.keys.max(4).
      select { |similarity| similarity >= SEMANTIC_SIMILARITY_THRESHOLD }.
      map { |similarity| similarity_to_id[similarity] }


    similar_subtopic_uuids = Subtopic.where(id: similar_subtopic_ids).pluck(:uuid)

    Recommendation.create! subtopic_id: subtopic_id,
                           first:  similar_subtopic_uuids[0],
                           second: similar_subtopic_uuids[1],
                           third:  similar_subtopic_uuids[2],
                           fourth: similar_subtopic_uuids[3]
  end
end


















#
