class Api::V1::PokemonController < ApplicationController
  def index
    @pokemon = Pokemon.all
    if @pokemon.blank?
      render json: {status: 200, message: "No Pokemon in the database, please create some!"}, status: 200
    elsif params[:sorted]
      pokemon_sorted
    elsif params[:min_hp]
      render json: PokemonSerializer.new(@pokemon.where('hp >= ?', params[:min_hp]))
    else
      render json: PokemonSerializer.new(@pokemon)
    end
  end

  def show
    if @search = Search.find_by(name: name)
      search_found
    else
      new_search
    end
  end

  def destroy
    user = User.find_by(api_key: params[:api_key])
    if user
      if pokemon = Pokemon.find_by(name: name.capitalize)
        pokemon.destroy
        Search.find_by(name: name).destroy
        render json: "#{pokemon.name} has been deleted", status: 202
      else
        render json: "Pokemon does not exist", status: 404
      end
    else
      render json: "API key is not valid", status: :unauthorized
    end
  end

  private
  def name
    params[:id].downcase
  end

  def pokemon_sorted
    if Pokemon.attribute_names.include?(params[:sorted])
      render json: PokemonSerializer.new(@pokemon.order(params[:sorted]))
    else
      render json: {status: 404, message: "Pokemon can only be sorted by name, weight, height, defense and hp"}, status: 404
    end
  end

  def search_found
    pokemon = Rails.cache.fetch("pokemon/#{name}", expires_in: 3.minutes) do
      Pokemon.find_by(search_id: @search.id)
    end
    if pokemon
      render json: PokemonSerializer.new(pokemon)
    else
      render json: {status: 404, message: "Pokemon does not exist"}, status: 404
    end
  end

  def new_search
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
