class CreatePokemons < ActiveRecord::Migration[5.2]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.float :weight
      t.float :height
      t.integer :attack
      t.integer :defense
      t.integer :hp
      t.references :search, foreign_key: true

      t.timestamps
    end
  end
end
