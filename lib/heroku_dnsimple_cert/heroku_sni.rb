class HerokuSni
  include HTTParty

  headers "Accept" => "application/vnd.heroku+json; version=3"
  raise_on [422, 500]

  def initialize(token, app_id)
    self.class.base_uri "https://api.heroku.com/apps/#{app_id}/sni-endpoints"
    self.class.headers "Authorization" => "Bearer #{token}"
  end

  def list
    self.class.get ""
  end

  def create(options)
    self.class.post "", body: options
  end

  def update(name, options)
    self.class.patch "/#{name}", body: options
  end
end
