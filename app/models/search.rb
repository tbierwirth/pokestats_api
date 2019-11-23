class Search < ApplicationRecord
  has_one :pokemon

  validates_presence_of :name
end
