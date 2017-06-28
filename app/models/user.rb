class User < ApplicationRecord
  has_many :commands
  #validates :username, presence: true, uniqueness: true, length: { maximum: 100 }
  #validates :price1, presence: true#, numericality: true
  #validates :price2, presence: true#, numericality: true
  #validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


end
