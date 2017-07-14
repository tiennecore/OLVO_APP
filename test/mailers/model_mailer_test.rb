require 'test_helper'

class ModelMailerTest < ActionMailer::TestCase
  test "notif_facturation" do
    mail = ModelMailer.notif_facturation
    assert_equal "Notif facturation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
