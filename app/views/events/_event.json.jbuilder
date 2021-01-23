json.extract! event, :id, :name, :max_capacity, :created_at, :updated_at
json.url event_url(event, format: :json)
