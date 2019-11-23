class PokeApiService
  def get_pokemon(name)
    get_json("/api/v2/pokemon/#{name}")
  end

  private
  def conn
    Faraday.new(url: "https://pokeapi.co") do |f|
      f.adapter Faraday.default_adapter
    end
  end

  def get_json(url)
    response = conn.get(url)
    if response.body.include?("Not Found")
      return
    else
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
