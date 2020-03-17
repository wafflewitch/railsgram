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

  has_many :follower_relationships, foreign_key: :following_id, class_name: 'Follow', dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy
  has_many :following, through: :following_relationships, source: :following

  def likes?(likeable)
    likeable.likes.where(user_id: id).any?
  end

  def follow(user_id)
    following_relationships.find_or_create_by(following_id: user_id)
  end

  def unfollow(user_id)
    following_relationships.where(following_id: user_id).destroy_all
  end

  def follows?(user_id)
    following_relationships.where(following_id: user_id).any?
  end
end
