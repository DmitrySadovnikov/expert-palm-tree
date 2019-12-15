class Bearer < ApplicationRecord
  has_many :stocks

  validates :name, presence: true
  validates :name, uniqueness: true
end
