json.extract! writer, :id, :name, :email, :type, :organization_id, :created_at, :updated_at
json.url writer_url(writer, format: :json)
