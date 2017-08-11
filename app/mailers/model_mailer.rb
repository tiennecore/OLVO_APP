class ModelMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.model_mailer.notif_facturation.subject
  #
  default from: "	sandboxddb07e277835439e9477d5ae571dda59.mailgun.org"
  def new_record_notification
  mail to: "wvetienne@gmail.com", subject: "Success! You did it."
end
end
