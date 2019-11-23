class Api::V1::PokemonController < ApplicationController
  def index
    pokemon = Pokemon.all
    if pokemon.blank?
      render json: {status: 200, message: "No Pokemon in the database, please create some!"}, status: 200
    else
      render json: PokemonSerializer.new(pokemon)
    end
  end

  def show
    if search = Search.find_by(name: name)
      pokemon = Rails.cache.fetch("pokemon/#{name}", expires_in: 3.minutes) do
        Pokemon.find_by(search_id: search.id)
      end
      if pokemon
        render json: PokemonSerializer.new(pokemon)
      else
        render json: {status: 404, message: "Pokemon does not exist"}, status: 404
      end
    else
      search = Rails.cache.fetch("search/#{name}", expires_in: 3.minutes) do
        Search.create(name: name)
      end
      pokemon = PokemonFacade.new(name, search).pokemon
      if pokemon.nil?
        render json: {status: 404, message: "Pokemon does not exist"}, status: 404
      else
        render json: PokemonSerializer.new(pokemon)
      end
    end
  end

  private
  def name
    params[:id].downcase
  end
end
