class Stock < ApplicationRecord
  belongs_to :bearer

  validates :bearer, :name, presence: true
  validates :name, uniqueness: true
end
