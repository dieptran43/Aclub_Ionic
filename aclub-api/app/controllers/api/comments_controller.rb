module Api
  class CommentsController < BaseController
    before_action :authenticate_user!, only: [:create]
    before_action :require_commentable!

    def index
      render json: ArrayPresenter.new(@commentable.comments.includes(:commenter).page(params[:page]), CommentPresenter)
    end

    def create
      comment = current_user.comment(@commentable, comment_params[:content], comment_params[:rate])
      if comment.valid?
        render json: CommentPresenter.new(comment)
      else
        render json: ModelErrorsPresenter.new(comment)
      end
    end

    private

    def comment_params
      params[:comment].permit(:commentable_type, :content, :rate)
    end

    def require_commentable!
      if has_params?([:commentable_type], :comment)
        commentable_id = params["#{comment_params[:commentable_type].downcase}_id"]
        @commentable = comment_params[:commentable_type].constantize.find_by(id: commentable_id)
        render_errors(I18n.t('base.api.not_found'), :not_found) unless @commentable
      end
    end
  end
end
