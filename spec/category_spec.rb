require 'spec_helper'
describe ExUA::Category, :vcr => true do
  context "general 1 page category" do
    subject{ExUA::Category.new(url: '/ru/video')}
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
    its(:uri){should eq(Addressable::URI.parse('http://www.ex.ua/ru/video'))}
  end
  context "general few pages category" do
    context "on third page" do
      subject{ExUA::Category.new(url: '/ru/video/foreign?p=2')}
      describe '#prev' do
        it 'returns a category with same url, but previous page number' do
          expect(subject.prev.uri.request_uri).to eq('/ru/video/foreign?p=1')
        end
      end
      describe '#next' do
        it 'returns a category with same url, but different page number' do
          subject.next.uri.request_uri.should eq('/ru/video/foreign?p=3')
        end
      end
    end
    context "on a first page" do
      subject{ExUA::Category.new(url: '/ru/video/foreign')}
      describe '#prev' do
        it 'raises error when no prev url found' do
          expect{subject.prev}.to raise_error(ExUA::Category::NotFound)
        end
      end
      describe '#page' do
        it 'return 0 as a page number' do
          expect(subject.page).to eq(0)
        end
      end
    end
  end
  context "item category" do
    subject{ExUA::Category.new(url: '/71902463')}
    its(:picture){should_not be_nil}
    describe '#items' do
      it 'has an array of items' do
        expect(subject.items.size).not_to eq(0)
      end
    end
  end
end
