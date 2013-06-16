# encoding: UTF-8

require "digest"
require "net/ftp"

architecture    = `uname -m`.strip

file_name       = "#{ENV['BUNDLE_ARCHIVE']}-#{architecture}.tgz"
file_path       = File.expand_path("~/#{file_name}")
lock_file       = File.join(File.expand_path(ENV["TRAVIS_BUILD_DIR"]), "Gemfile.lock")
digest_filename = "#{file_name}.sha2"
old_digest      = File.expand_path("~/remote_#{digest_filename}")

puts "Checking for changes"
bundle_digest = Digest::SHA2.file(lock_file).hexdigest
old_digest    = File.exists?(old_digest) ? File.read(old_digest) : ""

if bundle_digest == old_digest
  puts "=> There were no changes, doing nothing"
else
  if old_digest == ""
    puts "=> There was no existing digest, uploading a new version of the archive"
  else
    puts "=> There were changes, uploading a new version of the archive"
    puts "  => Old checksum: #{old_digest}"
    puts "  => New checksum: #{bundle_digest}"
  end

  puts "=> Preparing bundle archive"
  `cd ~ && tar -cjf #{file_name} .bundle`

  Net::FTP.open(ENV['CI_FTP_HOST']) do |ftp|
    ftp.login(ENV['CI_FTP_USER'], ENV['CI_FTP_PASS'])

    puts "=> Uploading the bundle"
    ftp.putbinaryfile(file_name, file_name, 1024)
    puts "=> Completing upload"

    puts "=> Uploading the digest file"
    ftp.putbinaryfile(digest_filename)
    puts "=> Completing upload"
  end
end

puts "All done now."
exit 0
