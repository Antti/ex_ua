desc 'Update spec data'
task :update_spec_data do
  require 'httparty'
  begin
    base_url = 'http://www.ex.ua'
    data_path = File.expand_path('../../spec/data', __FILE__)
    files = {'/ru/video' => 'index.html',
      '/ru/video' => 'ru_video.html',
      '/view/53667787?r=2,23775' => 'video_test.html',
      '/ru/video/foreign?r=23775' => 'foreign_video_russia.html'}
    files.each do |remote, local|
      url =  "#{base_url}#{remote}"
      puts url
      File.write(File.join(data_path, local), HTTParty.get(url))
    end
  rescue => e
    puts "Failed updating spec data: #{e.message}."
  end
end