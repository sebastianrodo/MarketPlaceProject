class SendEmailService
  def self.send_email(product)
    User.find_each do |user|
      NotifierMailer.email(user, product).deliver_later
    end
  end
end
