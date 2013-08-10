require 'spec_helper'
describe ExUA::Category do
  before { stub_client }
  context "general 1 page category" do
    subject{ExUA::Category.new(url: 'ru_video.html')}
    describe '#categories' do
      it 'returns list of child categories' do
        subject.categories.should be_kind_of(Array)
      end
      it 'has current category as a parent category for all childs' do
        subject.categories.all?{|c| c.parent == subject}.should be_true
      end
    end
    its(:items){should_not be_nil}
    its(:name){should_not be_nil}
    its(:description){should_not be_nil}
    its(:canonical_url){should_not be_nil}
    its(:next?){should be_false}
    its(:prev?){should be_false}
  end
  context "general few pages category" do
    subject{ExUA::Category.new(url: 'foreign_video_russia.html')}
    describe '#next' do
      it 'returns a category with same url, but different page number' do
        subject.next.url.should eq('/ru/video/foreign?r=23775&p=1')
      end
    end
    describe '#prev' do
      it 'returns a category with same url, but different page number' do
        pending 'find a page with prev'
        expect(subject.prev.url).to eq('')
      end
      it 'raises error when no prev url found' do
        expect{subject.prev}.to raise_error(ExUA::Category::NotFound)
      end
    end
  end
  context "item category" do
    subject{ExUA::Category.new(url: 'video_test.html')}
    its(:picture){should_not be_nil}
  end
end
