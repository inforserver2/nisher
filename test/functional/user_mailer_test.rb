require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "send_my_password" do
    mail = UserMailer.send_my_password
    assert_equal "Send my password", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
