# [Board] model serializer
class BoardSerializer < ActiveModel::Serializer
  attributes :id, :title, :status, :updated_at, :description, :card_ids
  attributes :branches_count, :cards_count, :last_update, :collections
  attributes :progress

  has_one :user, :embed => :id
  has_one :author, :embed => :id
  has_one :project, :embed => :id
  has_one :parent_board, :embed => :id
  has_one :cover, :embed => :id
  has_one :team, :embed => :id

  has_many :branches, :embed => :ids
  has_many :cards, :embed => :ids
  has_many :activities, :embed => :id
  has_many :memberships, :embed => :id
  has_many :topics, :embed => :id

  # Creates a nice timestamp to indicate when it was last time updated
  def last_update
    object.updated_at.to_s(:pretty)
  end

  # Returns how many times this was branched
  def branches_count
    object.branches.count
  end

  # Returns the number of cards
  def cards_count
    object.cards.count
  end

  # Returns collection/tag names
  def collections
    object.tags.pluck('name').map(&:titleize)
  end

  # Returns collection/tag names
  def progress
    completed_count = object.cards.pluck('title').reject(&:blank?).count
    cards_count > 0 ? ( completed_count.to_f / cards_count) * 100 : 0
  end

  # Hide collections for non public boards
  def include_collections?
    object.project_id.blank?
  end

  # Hide progress for non public boards
  def include_progress?
    !object.project_id.blank?
  end
end
