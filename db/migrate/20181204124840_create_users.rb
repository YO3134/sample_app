class CreateUsers < ActiveRecord::Migration[5.1]
  # データベースに与える変更を定義したchangeメソッド
  # changeメソッドはcreate_tableというRailsのメソッドを呼び、
  # ユーザーを保存するためのテーブルをデータベースに作成
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
