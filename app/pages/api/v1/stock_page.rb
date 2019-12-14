module Api::V1
  class StockPage < Tram::Page
    param :stock

    section :id, value: -> { stock.id }
    section :name, value: -> { stock.name }
    section :bearer_name, value: -> { stock.bearer.name }
  end
end
