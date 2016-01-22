if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(
    host: uri.host,
    port: uri.port,
    password: uri.password,
    timeout: 10.0,
  )
elsif Rails.env.test?
  REDIS = MockRedis.new
else
  REDIS = nil
end
