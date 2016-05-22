module ApplicationHelper

  # header navigation
  def reminder_link(user)
    if user.reminders.count > 0
      link_to "My Reminders", reminder_path(user.reminders.first.id)
    else
      link_to "Reminders", new_reminder_path
    end
  end

end
