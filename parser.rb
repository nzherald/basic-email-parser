require 'bundler'
Bundler.require

mails = Dir.glob('mail/*')

mails.each do |m|
  mail = Mail.read(m)
  puts 'From: ' + mail.from.join(', ')

  mail.body.parts.each do |part|
    puts part.decoded if part.content_type =~ /text\/plain/
  end

  mail.attachments.each do |attachment|
    filename = attachment.filename
    begin
      File.open('attachments/' + filename, "w+b", 0644) {|f| f.write attachment.body.decoded}
    rescue => e
      puts "Unable to save data for #{filename} because #{e.message}"
    end
  end
end
