class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@trivial.fun'
  layout 'mailer'
end
