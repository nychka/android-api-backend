class MarksController < ApiController
  before_action :authorize!
  before_action :set_user, only: [:create]
  # GET /marks
  def index
    marked_users = @current_user.marked_users
    render '/marks/show', locals: { status: 200, users: marked_users }, status: :ok
  end
  # POST /marks
  def create
    if @current_user.marks.create(marked_user_id: @user.id)
      render '/marks/create', locals: { status: 201, user: @user }, status: :created
    else
      #TODO: add error response
    end
  end
  # DELETE /marks/:id
  def destroy
    if mark = @current_user.marks.where(marked_user_id: params[:id]).limit(1).try(:first)
      mark.destroy
      render json: { status: 204 }, status: :no_content
    else
      # TODO: add error response
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
