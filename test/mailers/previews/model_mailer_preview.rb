# Preview all emails at http://localhost:3000/rails/mailers/model_mailer
class ModelMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/model_mailer/notif_facturation
  def notif_facturation
    ModelMailer.notif_facturation
  end

end
