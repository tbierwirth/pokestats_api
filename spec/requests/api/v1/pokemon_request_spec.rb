require 'rails_helper'

describe "Pokemon API" do
  describe "GET /pokemon" do
    it "can return all pokemon in the database" do
      5.times do
        create(:pokemon)
      end

      get '/api/v1/pokemon'
      pokemon = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(pokemon.count).to eq(5)
    end

    it "displays a message if no pokemon exists" do
      get '/api/v1/pokemon'
      results = JSON.parse(response.body, symbolize_names: true)
      expect(results[:message]).to eq("No Pokemon in the database, please create some!")
    end

    it "can sort by pokemon name" do
      create(:pokemon, name: "Z")
      create(:pokemon, name: "A")
      3.times do
        create(:pokemon)
      end

      get '/api/v1/pokemon?sorted=name'

      results = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response).to be_successful
      expect(results.count).to eq(5)
      expect(results.first[:attributes][:name]).to eq("A")
      expect(results.last[:attributes][:name]).to eq("Z")
    end

    it "returns an error if attempting to sort by an attribute that doesnt exist" do
      create(:pokemon, name: "Z")
      create(:pokemon, name: "A")
      3.times do
        create(:pokemon)
      end

      get '/api/v1/pokemon?sorted=rarity'
      expect(response).to_not be_successful
      results = JSON.parse(response.body, symbolize_names: true)
      expect(results[:message]).to eq("Pokemon can only be sorted by name, weight, height, defense and hp")
    end
  end

  it "returns pokemon with a minimum hp of 50" do
    create(:pokemon, hp: 55)
    create(:pokemon, hp: 60)
    3.times do
      create(:pokemon, hp: rand(20..49))
    end

    get '/api/v1/pokemon?min_hp=50'

    results = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(results.count).to eq(2)
    expect(results.first[:attributes][:hp]).to eq(55)
    expect(results.last[:attributes][:hp]).to eq(60)
  end

  describe "GET /pokemon/:name" do
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

    it "wont return a pokemon if it doesnt exist" do
      get '/api/v1/pokemon/notapokemon'
      expect(response).to_not be_successful
    end

    it "wont make another api call if the search exists and pokemon exists" do
      search = create(:search, name: "pikachu")
      pokemon = Pokemon.create(
        name: "Pikachu",
        weight: 13.23,
        height: 1.31,
        defense: 40,
        attack: 55,
        hp: 55,
        search_id: search.id
      )

      get '/api/v1/pokemon/pikachu'

      expect(response).to be_successful
      result = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
      expect(result[:name]).to eq("Pikachu")
      expect(Search.last.id).to eq(search.id)
      expect(Pokemon.last.id).to eq(pokemon.id)
    end

    it "wont make another api call if the search exists but no pokemon exists" do
      search = create(:search, name: "notapokemon")

      get '/api/v1/pokemon/notapokemon'

      expect(response).to_not be_successful
      expect(Search.last.id).to eq(search.id)
      expect(Pokemon.last).to be(nil)
    end
  end

  describe "DELETE /pokemon/:name" do
    it "can delete a pokemon if given an api_key and pokemon name" do
      search = create(:search, name: "pikachu")
      pokemon = create(:pokemon, name: "Pikachu", search_id: search.id)
      User.create!(username: "tyler@gmail.com", password: "password")
      request = {
      "api_key": "#{User.last.api_key}"
      }

      delete '/api/v1/pokemon/pikachu', params: request
      expect(response).to be_successful
    end
  end
end
