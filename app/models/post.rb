class Post < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  validates :image, attached: true

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
end