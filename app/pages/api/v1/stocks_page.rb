module Api::V1
  class StocksPage < Tram::Page
    option :page, default: -> { Rails.configuration.application[:pagination][:default_page] }
    option :per_page, default: -> { Rails.configuration.application[:pagination][:default_per_page] }

    section :data

    def data
      collection.map { |stock| StockPage.new(stock).to_h }
    end

    def collection
      Stock.visible.page(page).per(per_page).order(:name).includes(:bearer)
    end
  end
end
