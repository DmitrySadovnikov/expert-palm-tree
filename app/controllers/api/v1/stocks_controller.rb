module Api::V1
  class StocksController < BaseController
    def index
      render json: StocksPage.new(params.permit!.to_h.symbolize_keys).to_h
    end

    def create
      stock = ActiveRecord::Base.transaction { Stock.create!(bearer: bearer, name: name) }
      render json: { data: StockPage.new(stock).to_h }, status: :created
    end

    def update
      permitted_params[:bearer_name] ? stock.update!(bearer: bearer, name: name) : stock.update!(name: name)
      render json: { data: StockPage.new(stock).to_h }, status: :ok
    end

    def destroy
      stock.update!(is_deleted: true)
      head :ok
    end

    private

    def permitted_params
      params.permit(:name, :bearer_name)
    end

    def name
      permitted_params.require(:name)
    end

    def bearer
      @bearer ||= Bearer.find_or_create_by!(name: permitted_params.require(:bearer_name))
    end

    def stock
      @stock ||= Stock.visible.find(params.require(:id))
    end
  end
end
