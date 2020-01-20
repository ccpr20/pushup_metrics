module LeaderboardHelper
  def public_avatar(user)
    gravatar_tag user['email'], size: 25, default: "https://api.adorable.io/avatars/25/#{user['email']}"
  end
end
