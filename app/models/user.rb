class User < ApplicationRecord
    attr_accessor :remember_token, :activation_token
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
