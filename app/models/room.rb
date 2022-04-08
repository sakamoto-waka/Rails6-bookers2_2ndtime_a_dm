class Room < ApplicationRecord
  
  has_many :chats, dependent: :destroy
  # 1つの部屋には2人のuserがいるからhas_many
  has_many :user_rooms, dependent: :destroy
  
end
