class Post < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  validates :image, attached: true

  scope :of_followed_users, -> (following_users) { where(user_id: following_users) }

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  accepts_nested_attributes_for :comments, reject_if: proc { |attributes| attributes['body'].blank? }
end
