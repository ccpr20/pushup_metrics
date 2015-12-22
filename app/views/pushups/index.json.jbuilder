json.array!(@pushups) do |pushup|
  json.extract! pushup, :id, :amount
  json.url pushup_url(pushup, format: :json)
end
