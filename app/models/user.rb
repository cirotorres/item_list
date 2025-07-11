class User < ApplicationRecord
    has_secure_password
    validates :email, presence: true, uniqueness: true
    has_many :carts
    has_many :favorites
    has_many :banners, dependent: :destroy
end
