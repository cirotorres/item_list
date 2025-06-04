# spec/integration/items_spec.rb
require 'swagger_helper'

RSpec.describe 'Items API', type: :request do
  path '/items' do
    get('list items') do
      tags 'Items'
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end
end
