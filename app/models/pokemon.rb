class Pokemon < ApplicationRecord
  belongs_to :search

  validates_presence_of :name, :weight, :height, :attack, :defense, :hp
end
