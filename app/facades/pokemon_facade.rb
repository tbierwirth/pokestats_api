class PokemonFacade
  def initialize(name, search)
    @name = name
    @search = search
  end

  def pokemon
    results = get_pokemon(@name)
    unless results.nil?
      details = {
        name: results[:name].capitalize,
        height: (results[:height]/3.048).round(2),
        weight: (results[:weight]/4.536).round(2),
        defense: results[:stats][3][:base_stat],
        attack: results[:stats][4][:base_stat],
        hp: results[:stats][5][:base_stat],
        search_id: @search.id
      }
      Pokemon.create(details)
    end
  end

  private

  def get_pokemon(name)
    PokeApiService.new.get_pokemon(name)
  end
end
