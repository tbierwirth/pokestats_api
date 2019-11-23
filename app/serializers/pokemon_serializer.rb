class PokemonSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :weight, :height, :defense, :attack, :hp
end
