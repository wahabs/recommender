class Subtopic < ActiveRecord::Base
  def to_s
    "#{name}\n\n#{description}"
  end
end
