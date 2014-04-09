class CommentsController < ApplicationController
  def create
    params[:comment][:user_id] = current_user.id unless current_user.nil?
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to article_path(id: params[:article_id]) << "#comment_#{@comment.id}"
    else
      redirect_to article_path(id: params[:article_id])
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:parent_id, :user_id, :content, :article_id)
  end
end
