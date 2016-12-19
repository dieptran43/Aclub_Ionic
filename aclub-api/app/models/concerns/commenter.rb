module Commenter
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def commenter
      has_many :comments, as: :commenter, dependent: :destroy
      include InstanceMethods
    end
  end

  module InstanceMethods
    def comment(commentable, text, rate = 5)
      comments.create(commentable: commentable, content: text, rate: rate)
    end
  end
end