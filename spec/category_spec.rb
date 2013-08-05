require 'spec_helper'
describe ExUA::Category do
  describe '#categories'
  context "general category" do
    subject{ExUA::Category.new(client, url: 'ru_video.html')}
    its(:items){should_not be_nil}
    its(:name){should eq("\u0412\u0438\u0434\u0435\u043E [RU - \u0440\u0443\u0441\u0441\u043A\u0438\u0439]")}
    its(:description){should_not be_nil}
    its(:canonical_url){should_not be_nil}
    describe '#next'
    describe '#prev'
  end
  context "item category" do
    subject{ExUA::Category.new(client, url: 'video_test.html')}
    its(:picture){should_not be_nil}
  end
end
