class Pet < ApplicationRecord
  validates :name, presence: true
end
