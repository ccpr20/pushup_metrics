module LeaderboardHelper
  def public_avatar(user)
    gravatar_tag user['email'], size: 25, default: "https://api.adorable.io/avatars/25/#{user['email']}"
  end

  def calculate_age(dob)
    if dob != nil
      current_date = Date.today
      age = current_date.year - dob&.year

      # Check if the birthday has already occurred this year
      age -= 1 if current_date < dob + age.years

      age
    end
  end
end
