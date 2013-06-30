class UsersController < ApplicationController
  before_filter :check_permission, only: [:new, :create]
  before_filter :check_existing_student, only: [:new, :create]

  def new
    @user = User.new
    @user = UserCreationForm.new(session[:enrolment_number])
  end

  def create
    @user = UserCreationForm.new(session[:enrolment_number])
    if @user.submit(params[:user])
      #UserMailer.registration_confirmation(@user).deliver
      session[:user_id] = @user.id
      redirect_to overview_index_path, notice: t('sign_up')
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'Details were successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

private
    def check_permission
      redirect_to root_url unless session[:enrolment_number].present?
    end

    def check_existing_student
      redirect_to root_url if Student.find_by_enrolment_number(session[:enrolment_number]) and session[:enrolment_number]
    end

end
