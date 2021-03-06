
require 'bcrypt'
require 'dm-validations'

class User
  include DataMapper::Resource

  has n, :peeps

  property :id, Serial
  property :email, String
  property :password_digest, String, length: 70

  attr_reader :password
  attr_accessor :password_confirmation

  validates_confirmation_of :password

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
    user = first(email: email)
    if user && BCrypt::Password.new(user.password_digest) == password
        user
    else
        nil
    end
  end

end
