class Api::V1::PokemonController < ApplicationController
  def show
    if search = Search.find_by(name: name)
      if pokemon = Pokemon.find_by(search_id: search.id)
        render json: PokemonSerializer.new(pokemon)
      else
        render json: {status: 404, message: "Pokemon does not exist"}, status: 404
      end
    else
      search = Search.create(name: name)
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
