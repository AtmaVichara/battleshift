class User < ApplicationRecord
  has_secure_password
  validates_presence_of :email, :name
  validates :password, presence: true, on: :creates
  validates :password, presence: true, on: :update, allow_blank: true
  validates_confirmation_of :password
  enum status: %w(inactivated activated)

  def activate
    update(status: 1)
  end

  def generate_api
    update(api_key: SecureRandom.hex(32))
  end

  def send_activation
    UserActivationMailer.activation_email(self).deliver_now
  end
end
