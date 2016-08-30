class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception

  # making url helpers https in production
  def default_url_options(options = {})
    if Rails.env.production?
      { protocol: :https }.merge(options)
    else
      options
    end
  end
end
