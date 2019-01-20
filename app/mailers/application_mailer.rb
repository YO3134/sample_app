class ApplicationMailer < ActionMailer::Base
  default from: "noreply@example.com"
  # 実際に有効化メールで使える
  layout 'mailer'
end
