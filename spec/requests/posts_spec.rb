require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe 'GET /api/posts' do
    context 'with correct request' do
      before { get '/api/posts?tags=tech,science,history&sortBy=id' }

      it 'returns todos' do
        json = JSON(response.body)
        expect(json).not_to be_empty
        expect(json["posts"].size).to eq(61)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'with empty tags request' do
      before { get '/api/posts?tags=' }

      it 'returns error' do
        json = JSON(response.body)
        expect(json["error"]).to eq(TAGS_REQUIRED)
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end
    end

    context 'with incorrect direction request' do
      before { get '/api/posts?tags=tech&direction=abc' }

      it 'returns error' do
        json = JSON(response.body)
        expect(json["error"]).to eq(DIRECTION_INVALID)
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end
    end

    context 'with incorrect sortBy request' do
      before { get '/api/posts?tags=tech&sortBy=abc' }

      it 'returns error' do
        json = JSON(response.body)
        expect(json["error"]).to eq(SORTBY_INVALID)
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'GET /api/ping' do
    context 'with correct request' do
      before { get '/api/ping' }
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
