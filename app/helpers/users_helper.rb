module UsersHelper
  def gravatar_for user, size: Settings.gravatar_size_default
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    gravatar_url = "https://s.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end
end
