class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_and_belongs_to_many :venues

  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :validatable, stretches: 16

  enum role: { super_user: 1, admin: 2, host: 3, player: 4 }

  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :player
  end
end
