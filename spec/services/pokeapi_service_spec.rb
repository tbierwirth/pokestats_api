require 'rails_helper'

RSpec.describe PokeApiService do
  before :each do
    pikachu = File.open('./spec/fixtures/pikachu.json')
    stub_request(:get, "https://pokeapi.co/api/v2/pokemon/pikachu").
      to_return(status: 200, body: pikachu)
    notapokemon = File.open('./spec/fixtures/notapokemon.json')
    stub_request(:get, "https://pokeapi.co/api/v2/pokemon/notapokemon").
      to_return(status: 200, body: notapokemon)
  end

  describe "instance methods" do
    context "#get_pokemon" do
      it "can return a pokemon" do
        name = "pikachu"
        service = PokeApiService.new
        pokemon = service.get_pokemon(name)
        expect(pokemon[:name]).to eq("pikachu")
        expect(pokemon[:weight]).to eq(60)
        expect(pokemon[:height]).to eq(4)
        expect(pokemon[:stats][3][:stat][:name]).to eq("defense")
        expect(pokemon[:stats][4][:stat][:name]).to eq("attack")
        expect(pokemon[:stats][5][:stat][:name]).to eq("hp")
      end

      it "wont return a pokemon if it doesnt exist" do
        name = "notapokemon"
        service = PokeApiService.new
        pokemon = service.get_pokemon(name)
        expect(pokemon).to be(nil)
      end
    end
  end
end
