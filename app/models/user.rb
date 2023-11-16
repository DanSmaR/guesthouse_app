class User < ApplicationRecord
  validates :name, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: { guest: 0, guesthouse_owner: 1 }
  has_one :guesthouse_owner, dependent: :destroy
  has_one :guest, dependent: :destroy
end
