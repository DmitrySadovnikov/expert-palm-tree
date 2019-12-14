require 'rails_helper'

describe Api::V1::StocksController do
  describe '#index' do
    subject { get '/api/v1/stocks', params: params }

    let(:params) do
      {
        page: 1,
        per_page: 1
      }
    end

    let!(:stocks) { create_list(:stock, 2) }
    let!(:deleted_stocks) { create(:stock, is_deleted: true) }

    shared_context 'with common cases' do
      it 'returns 200' do
        subject
        expect(response).to have_http_status(200)
      end

      it 'does not returns deleted stock' do
        subject
        expect(json_data.map { |hash| hash['id'] }).not_to include(deleted_stocks.id)
      end
    end

    it_behaves_like 'with common cases'

    it 'returns only 1 stock' do
      subject
      stock = stocks.min_by(&:name)
      expect(json_data).to eq(
        [
          json_erb_fixture('api/v1/stock.json.erb',
                           id: stock.id,
                           name: stock.name,
                           bearer_name: stock.bearer.name)
        ]
      )
    end

    context 'without params' do
      let(:params) {}

      it_behaves_like 'with common cases'

      it 'returns all stocks' do
        subject
        expectation = stocks.sort_by(&:name).map do |stock|
          json_erb_fixture('api/v1/stock.json.erb',
                           id: stock.id,
                           name: stock.name,
                           bearer_name: stock.bearer.name)
        end
        expect(json_data).to eq(expectation)
      end
    end
  end

  describe '#create' do
    subject { post '/api/v1/stocks', params: params }

    let(:created_stock) { Stock.last }

    shared_context 'with successful cases' do
      it 'returns 201' do
        subject
        expect(response).to have_http_status(201)
      end

      it 'creates Stock' do
        expect { subject }.to change(Stock, :count).by(1)
      end

      it 'returns json' do
        subject
        expect(json_data).to eq(
          json_erb_fixture('api/v1/stock.json.erb',
                           id: created_stock.id,
                           name: created_stock.name,
                           bearer_name: created_stock.bearer.name)
        )
      end
    end

    shared_context 'with bad request' do |error|
      it 'returns 400' do
        subject
        expect(response).to have_http_status(400)
      end

      it 'returns json' do
        subject
        expect(json_response).to eq({ error: error }.as_json)
      end

      it 'does not create Stock' do
        expect { subject }.not_to change(Stock, :count)
      end

      it 'does not create Bearer' do
        expect { subject }.not_to change(Bearer, :count)
      end
    end

    context 'when Stock and Bearer do not exist' do
      let(:params) do
        {
          name: Faker::Lorem.word,
          bearer_name: Faker::Lorem.word
        }
      end

      it_behaves_like 'with successful cases'

      it 'creates Bearer' do
        expect { subject }.to change(Bearer, :count).by(1)
      end
    end

    context 'when Bearer exists' do
      let!(:bearer) { create(:bearer) }

      let(:params) do
        {
          name: Faker::Lorem.word,
          bearer_name: bearer.name
        }
      end

      it_behaves_like 'with successful cases'

      it 'does not create Bearer' do
        expect { subject }.not_to change(Bearer, :count)
      end
    end

    context 'when Stock exists' do
      let!(:stock) { create(:stock) }

      let(:params) do
        {
          name: stock.name,
          bearer_name: Faker::Lorem.word
        }
      end

      it_behaves_like 'with bad request', 'Validation failed: Name has already been taken'
    end

    context 'without name' do
      let(:params) do
        {
          bearer_name: Faker::Lorem.word
        }
      end

      it_behaves_like 'with bad request', 'param is missing or the value is empty: name'
    end

    context 'without bearer_name' do
      let(:params) do
        {
          name: Faker::Lorem.word
        }
      end

      it_behaves_like 'with bad request', 'param is missing or the value is empty: bearer_name'
    end

    context 'without params' do
      let(:params) {}

      it_behaves_like 'with bad request', 'param is missing or the value is empty: bearer_name'
    end
  end

  describe '#update' do
    subject { patch "/api/v1/stocks/#{stock_id}", params: params }

    let!(:stock) { create(:stock) }
    let!(:stock_id) { stock.id }
    let(:params) do
      {
        name: Faker::Lorem.word,
        bearer_name: Faker::Lorem.word
      }
    end

    shared_context 'with successful cases' do
      it 'returns 200' do
        subject
        expect(response).to have_http_status(200)
      end

      it 'changes Stock name' do
        expect { subject }.to change { stock.reload.name }.to(params[:name])
      end

      it 'returns json' do
        subject
        expect(json_data).to eq(
          json_erb_fixture('api/v1/stock.json.erb',
                           id: stock.reload.id,
                           name: stock.name,
                           bearer_name: stock.bearer.name)
        )
      end
    end

    shared_context 'with bad request' do |error|
      it 'returns 400' do
        subject
        expect(response).to have_http_status(400)
      end

      it 'returns json' do
        subject
        expect(json_response).to eq({ error: error }.as_json)
      end

      it 'does not change Stock name' do
        expect { subject }.not_to change { stock.reload.name }
      end

      it 'does not change Stock bearer' do
        expect { subject }.not_to change { stock.reload.bearer_id }
      end

      it 'does not create Bearer' do
        expect { subject }.not_to change(Bearer, :count)
      end
    end

    context 'with new bearer_name' do
      it_behaves_like 'with successful cases'

      it 'creates Bearer' do
        expect { subject }.to change(Bearer, :count).by(1)
      end
    end

    context 'with old bearer_name' do
      let(:params) do
        {
          name: Faker::Lorem.word,
          bearer_name: stock.bearer.name
        }
      end

      it_behaves_like 'with successful cases'

      it 'does not create Bearer' do
        expect { subject }.not_to change(Bearer, :count)
      end

      it 'does not change Stock bearer' do
        expect { subject }.not_to change { stock.reload.bearer_id }
      end
    end

    context 'without bearer_name' do
      let(:params) do
        {
          name: Faker::Lorem.word
        }
      end

      it_behaves_like 'with successful cases'

      it 'does not create Bearer' do
        expect { subject }.not_to change(Bearer, :count)
      end

      it 'does not change Stock bearer' do
        expect { subject }.not_to change { stock.reload.bearer_id }
      end
    end

    context 'when Stock does not exist' do
      let(:stock_id) { SecureRandom.uuid }

      it 'returns 404' do
        subject
        expect(response).to have_http_status(404)
      end

      it 'returns json' do
        subject
        expect(json_response).to eq({ error: 'Resource not found' }.as_json)
      end

      it 'does not create Bearer' do
        expect { subject }.not_to change(Bearer, :count)
      end

      it 'does not change Stock name' do
        expect { subject }.not_to change { stock.reload.name }
      end

      it 'does not change Stock bearer' do
        expect { subject }.not_to change { stock.reload.bearer_id }
      end
    end

    context 'when Stock name has already been taken' do
      let!(:old_stock) { create(:stock) }

      let(:params) do
        {
          name: old_stock.name
        }
      end

      it_behaves_like 'with bad request', 'Validation failed: Name has already been taken'
    end

    context 'without params' do
      let(:params) {}

      it_behaves_like 'with bad request', 'param is missing or the value is empty: name'
    end
  end

  describe '#destroy' do
    subject { delete "/api/v1/stocks/#{stock_id}" }

    let!(:stock) { create(:stock) }
    let!(:stock_id) { stock.id }

    context 'with successful cases' do
      it 'returns 200' do
        subject
        expect(response).to have_http_status(200)
      end

      it 'changes Stock is_deleted' do
        expect { subject }.to change { stock.reload.is_deleted }.to(true)
      end
    end

    context 'when Stock does not exist' do
      let(:stock_id) { SecureRandom.uuid }

      it 'returns 404' do
        subject
        expect(response).to have_http_status(404)
      end

      it 'returns json' do
        subject
        expect(json_response).to eq({ error: 'Resource not found' }.as_json)
      end

      it 'does not change Stock is_deleted' do
        expect { subject }.not_to change { stock.reload.is_deleted }
      end
    end
  end
end
