if Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    address:              'smtp.sendgrid.net',
    authentication:       :plain,
    domain:               'abiteapp.com',
    enable_starttls_auto: true,
    password:             ENV['SENDGRID_PASSWORD'],
    port:                 587,
    user_name:            ENV['SENDGRID_USERNAME']
  }
else
  ActionMailer::Base.smtp_settings = {
    address:              'smtp.gmail.com',
    authentication:       :plain,
    domain:               'abiteapp.com',
    enable_starttls_auto: true,
    password:             '',
    port:                 587,
    user_name:            'hello@abiteapp.com'
  }
end