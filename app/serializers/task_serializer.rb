class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title

  has_many :tags, serializer: TagSerializer
end
