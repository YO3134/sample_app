class Micropost < ApplicationRecord
  belongs_to :user
  #ユーザーと１対１の関係 コマンドを実行したときにuser:referencesという引数
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end

# ラムダ式 (Stabby lambda) という文法を使っています。これは、Procやlambda (もしくは無名関数)と呼ばれるオブジェクトを作成する文法です。
#->というラムダ式は、ブロック (4.3.2) を引数に取り、Procオブジェクトを返します
