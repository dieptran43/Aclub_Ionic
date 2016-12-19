class Comment < ActiveRecord::Base
  default_scope -> { order('created_at DESC') }

  paginates_per 20

  validates :rate, :inclusion => 1..10

  belongs_to :commentable, polymorphic: true
  belongs_to :commenter, polymorphic: true
end
