# encoding: utf-8
require_relative 'libraries/s3'

class TravisTest
  class << self
    def set_s3
      s3 = S3.new()
      S3.show_object_contents(ENV['S3_SSH_Key_Bucket'], ENV['S3_SSH_Key_Name'])
    end
  end
end
pem = TravisTest.set_s3
File.write('./hlee-lab.pem', pem)