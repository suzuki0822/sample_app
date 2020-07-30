class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message: "should be less than 5MB" }
  has_many :likes, dependent: :destroy
  has_many :iine_users, through: :likes, source: :user
                                      
   # 表示用のリサイズ済み画像を返す
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
  
  def iine(user)
    likes.create(user_id: user.id)
  end
  
  # マイクロポストのいいねを解除する
  def uniine(user)
    likes.find_by(user_id: user.id).destroy
  end
  
  # 現在のユーザーがいいねしてたらtrueを返す
  def iine?(user)
    iine_users.include?(user)
  end
  
end
