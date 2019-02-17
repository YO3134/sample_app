class Micropost < ApplicationRecord
  belongs_to :user
  #ユーザーと１対１の関係 コマンドを実行したときにuser:referencesという引数
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  #mount_uploader 引数に属性名のシンボルと生成されたアップローダーのクラス名を取ります。
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  private

  # アップロードされた画像のサイズをバリデーションする
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end

# ラムダ式 (Stabby lambda) という文法を使っています。これは、Procやlambda (もしくは無名関数)と呼ばれるオブジェクトを作成する文法です。
#->というラムダ式は、ブロック (4.3.2) を引数に取り、Procオブジェクトを返します
