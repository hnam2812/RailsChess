class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable
  validates :last_name, :first_name, presence: true

  def full_name
    "#{last_name} #{first_name}"
  end
end
