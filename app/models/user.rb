class User < ApplicationRecord
    has_many :microposts, dependent: :destroy

    #能動的関係に対して１対多（has_many）の関連付けを実装する
    has_many :active_relationships, class_name: "Relationship",
                                    foreign_key: "follower_id",
                                    dependent: :destroy

    #受動的関係を使ってuser.followersを実装する
    has_many :passive_relationships, class_name: "Relationship",
                                    foreign_key: "followed_id",
                                    dependent: :destroy

    has_many :following, through: :active_relationships, source: :followed
    # following配列の元はfollowed idの集合である」ということを明示的にRailsに伝える
    # フォローしているユーザーを配列の様に扱う

    has_many :followers, through: :passive_relationships, source: :follower
    #上記↑:sourceキーは省略可能 has_many :followingとの類似性を強調させるため

    attr_accessor :remember_token, :activation_token, :reset_token
    before_save :downcase_email
    before_create :create_activation_digest
    validates :name, presence: true, length: { maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    # validates(:name, presence: true)
    validates :email, presence: true, length: { maximum: 255},
            format: { with: VALID_EMAIL_REGEX},
            uniqueness:{ case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST:
                                                   BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    #ランダムなトークン
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

    def remember
      self.remember_token = User.new_token
      update_attribute(:remember_digest, User.digest(remember_token))
    end

    # 渡されたトークンがダイジェストと一致したらtrueを返す
    # 引数を一般化し、文字列の式展開も利用 remember_token -> attribute, token
    def authenticated?(attribute, token)
      # digest = self.send("#{attribute}_digest")
      digest = send("#{attribute}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end

    #Userモデルにユーザー有効化メソッドを追加する
    # ユーザーのログイン情報を破棄する
    def forget
      update_attribute(:remember_digest, nil)
    end

    #アカウントを有効にする
    def activate
      update_attribute(:activated, true)
      update_attribute(:activated_at, Time.zone.now)
    end

    #有効化のメールを送信する
    def send_activation_email
      UserMailer.account_activation(self).deliver_now
    end

    #Userモデルにパスワード再設定用メソッドを追加する
    #パスワード再設定の属性を設定する
    def create_reset_digest
      self.reset_token = User.new_token
      update_attribute(:reset_digest, User.digest(reset_token))
      update_attribute(:reset_sent_at, Time.zone.now)
    end

    #パスワード再設定のメールを送信する
    def send_password_reset_email
      UserMailer.password_reset(self).deliver_now
    end

    # パスワード再設定の期限が切れている場合はをtrue返す
    def password_reset_expired?
      # 「パスワード再設定メールの送信時刻が、現在時刻より２時間以上前の場合」
      reset_sent_at < 2.hours.ago
    end

    # ユーザーのステータスフィードを返す
    def feed
      following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
      Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)

      # Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
      # following_ids: following_ids, user_id: id)

      #Micropost.where("user_id = ?", id)
      #?によってSQLクエリに代入する前にidがエスケープされるため、SQLインジェクションと呼ばれる
      #深刻なセキュリティーホールを避けることができる
    end

    #ユーザーをフォローする
    def follow(other_user)
      following << other_user
    end

    #ユーザーのフォローを解除する
    def unfollow(other_user)
      active_relationships.find_by(followed: other_user.id).destroy
    end
    
    #現在のユーザーがフォローしていたらtrueを返す
    def following?(other_user)
      following.include?(other_user)
    end

  private
    # メールアドレスをすべて小文字にする
    def downcase_email
      #self.email = email.downcase
      self.email.downcase!
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
# 6.1.2 practice1.2 retry
