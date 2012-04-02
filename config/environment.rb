# Load the rails application
require File.expand_path('../application', __FILE__)

CFG=YAML::load_file("#{Rails.root.to_s}/config/sys.yml")
Rails.env=CFG['env']
#Rails.env="development"
#Rails.env="production"
WillPaginate.per_page = 10
# Initialize the rails application
Networks::Application.initialize!
