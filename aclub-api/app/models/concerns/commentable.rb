module Commentable
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def commentable
      has_many :comments, as: :commentable, dependent: :destroy
      include InstanceMethods
    end
  end

  module InstanceMethods
    def average_rating
      comments.empty? ? nil : comments.sum(:rate) / comments.count
    end

    def comments_count
      comments.count
    end
  end
end