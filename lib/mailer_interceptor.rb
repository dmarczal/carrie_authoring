module MailerInterceptor
  def self.delivering_email(email)
    email.body.raw_source << "\n\nOriginally sent to #{email.to.first}\n\n"
    email.to = AppConfig.mail[:interceptor]
  end
end
