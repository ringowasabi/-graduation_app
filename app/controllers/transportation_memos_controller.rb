class TransportationMemosController < ApplicationController
  before_action :require_login

  def index
    @transportation_memos = TravelExpenseMemo
                             .joins(:destination)
                             .includes(:destination)
                             .where(destinations: { user_id: current_user.id })
                             .order(created_at: :desc)
  end

  def new
    @transportation_memo = TravelExpenseMemo.new
    set_destinations
  end

  def create
    destination = current_user.destinations.find_by(id: transportation_memo_params[:destination_id])
    @transportation_memo = TravelExpenseMemo.new(memo_attributes)

    if destination.nil?
      @transportation_memo.errors.add(:destination, "を選択してください")
      render_new_with_error
    else
      @transportation_memo.destination = destination

      if @transportation_memo.save
        redirect_to transportation_memo_completion_path, notice: "交通費メモを登録しました。"
      else
        render_new_with_error
      end
    end
  end

  def completion; end

  private

  def transportation_memo_params
    params.require(:travel_expense_memo).permit(:destination_id, :departure_place, :arrival_place, :one_way_fare)
  end

  def memo_attributes
    transportation_memo_params.except(:destination_id)
  end

  def set_destinations
    @destinations = current_user.destinations.order(:name)
  end

  def render_new_with_error
    set_destinations
    flash.now[:alert] = "入力内容を確認してください。"
    render :new, status: :unprocessable_entity
  end
end
