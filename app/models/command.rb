class Command < ApplicationRecord
  belongs_to :user

validates :adress, presence: true
validates :zipcode, presence: true, numericality: true
validates_length_of :zipcode, is: 5
validates :unit, presence: true, numericality: true
end
