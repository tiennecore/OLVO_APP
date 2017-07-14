class ModelMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.model_mailer.notif_facturation.subject
  #
  default from: "wvetienne@gmail.com"
  def new_record_notification
  mail to: "wvetienne@gmail.com", subject: "Success! You did it."
end
end
