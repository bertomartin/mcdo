class SessionsController < ApplicationController

  before_filter :require_login, only: [:show, :destroy]

  def create
    @user = User.find_by_email(params[:email])

    respond_to do |format|
      if @user.try(:authenticate, params[:password])

        # we store the @user.id in the session,
        # so we can fetch it in a later call
        session[:user_id] = @user.id

        format.json { render json: { status: "authenticated" }, status: :created, location: session_path }
      else
        format.json { render json: { status: "not authenticated" }, status: :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.json { render json: { status: "authenticated" } }
    end
  end

  def destroy
    respond_to do |format|
      reset_session
      format.json { render json: { status: "not authenticated" } }
    end
  end
end
