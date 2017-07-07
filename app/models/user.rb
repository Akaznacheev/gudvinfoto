class User < ActiveRecord::Base
  enum role: %i(user vip admin)
  after_initialize :set_default_role, if: :new_record?
  has_many :books, dependent: :destroy

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:vkontakte]

  def self.find_for_vkontakte_oauth(access_token)
    if user = User.find_by(url: access_token.info.urls.Vkontakte)
      user
    else
      User.create!(
        provider: access_token.provider, url: access_token.info.urls.Vkontakte,
        name: access_token.info.name, nickname: access_token.extra.raw_info.nickname,
        email: access_token.extra.raw_info.id.to_s + '@vk.com', password: Devise.friendly_token[0, 20]
      )
    end
  end
end
