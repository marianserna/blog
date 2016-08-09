class Admin::BaseController < ApplicationController
  #before any action happens,call this devise method: You can't visit
  # the section unless you're authenticated
  before_action :authenticate_user!
  # Anything in the admin section will use the admin layout
  layout 'admin'
end
