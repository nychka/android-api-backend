class MarksController < ApiController
  before_action :authorize!
  # GET /marks
  def index
    marked_users = @current_user.marked_users
    render '/marks/show', locals: { status: 200, users: marked_users }, status: :ok
  end
  # POST /marks
  def create
  end
  # DELETE /marks/:id
  def destroy
  end
end
