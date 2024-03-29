class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  def new
    @comment = Comment.new
  end

  def create
    @gram = Gram.find_by_id(params[:gram_id])
    return render_not_found if @gram.blank?

    if current_user
      @gram.comments.create(comment_params.merge(user: current_user))
      redirect_to root_path
    else
      redirect_to new_user_session_path
    end

  end

private

  def comment_params
    params.require(:comment).permit(:message, :user_id, :gram_id)
  end

end
