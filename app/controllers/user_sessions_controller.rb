class UserSessionsController < ApplicationController
  def new; end

  def create
    user = login(params[:email], params[:password])

    if user
      redirect_to transportation_memos_path, notice: "ログインしました。"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません。"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "ログアウトしました。"
  end
end
