class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, uniqueness: true, presence: true

  has_one_attached :avatar

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :posts, dependent: :destroy

  def likes?(likeable)
    likeable.likes.where(user_id: id).any?
  end
end
