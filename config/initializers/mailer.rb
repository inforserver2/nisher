ActionMailer::Base.default :from => CFG['email-contact']
ActionMailer::Base.layout 'application_mailer'
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address              => CFG['mail']['address'],
  :port                 => CFG['mail']['port'],
  :domain               => CFG['domain'],
  :user_name            => CFG['mail']['user_name'],
  :password             => CFG['mail']['password'],
  :authentication       => CFG['mail']['authentication'],
  :enable_starttls_auto => CFG['mail']['enable_starttls_auto']
}

ActionDispatch::Http::URL.tld_length = CFG["tldl"]
ActionMailer::Base.default_url_options={:host=>CFG["domain"]}
ActionController::Base.asset_host = CFG["prot"]
ActionMailer::Base.asset_host = CFG["prot"]
