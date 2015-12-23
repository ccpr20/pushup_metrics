json.array!(@reminders) do |reminder|
  json.extract! reminder, :id, :phone_number, :time, :references
  json.url reminder_url(reminder, format: :json)
end
