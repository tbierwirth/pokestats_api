require 'rails_helper'

describe "Pokemon API" do
  describe "GET /pokemon" do
    before :each do
      pikachu = File.open('./spec/fixtures/pikachu.json')
      stub_request(:get, "https://pokeapi.co/api/v2/pokemon/pikachu").
        to_return(status: 200, body: pikachu)
      notapokemon = File.open('./spec/fixtures/notapokemon.json')
      stub_request(:get, "https://pokeapi.co/api/v2/pokemon/notapokemon").
        to_return(status: 200, body: notapokemon)
    end

    it "can return a pokemon if the pokemon exists" do
      get '/api/v1/pokemon/pikachu'

      expect(response).to be_successful
      pokemon = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
      expect(pokemon[:name]).to eq("Pikachu")
      # Weight converted from hectograms to pounds
      expect(pokemon[:weight]).to eq(13.23)
      # Height converted from decimeters to feet
      expect(pokemon[:height]).to eq(1.31)
      expect(pokemon[:defense]).to eq(40)
      expect(pokemon[:attack]).to eq(55)
      expect(pokemon[:hp]).to eq(35)
    end
  end
end
