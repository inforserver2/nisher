require 'test_helper'

class MatrixMailerTest < ActionMailer::TestCase
  test "meta" do
    mail = MatrixMailer.meta
    assert_equal "Meta", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
