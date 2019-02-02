class Micropost < ApplicationRecord
  belongs_to :user
  #ユーザーと１対１の関係 コマンドを実行したときにuser:referencesという引数
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
