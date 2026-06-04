class DestinationsController < ApplicationController
  before_action :require_login

  def new
    @destination = Destination.new
    set_destinations
  end

  def create
    @destination = current_user.destinations.build(destination_params)

    if @destination.save
      redirect_to new_destination_path, notice: "訪問先を登録しました。"
    else
      set_destinations
      flash.now[:alert] = "入力内容を確認してください。"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def destination_params
    params.require(:destination).permit(:name)
  end

  def set_destinations
    @destinations = current_user.destinations.order(:name)
  end
end
