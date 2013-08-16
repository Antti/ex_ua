require 'spec_helper'
describe ExUA::Client, :vcr => true do
  subject{ described_class }
  describe '#available_languages' do
    it 'returns list of available languages' do
      subject.available_languages.should be_kind_of(Hash)
    end
    it 'includes known languages' do
      known_languages = ["en", "ru", "uk"]
      (subject.available_languages.keys & known_languages).sort.should eq(known_languages)
    end
  end
  describe '#base_categories' do
    it 'lists base categories for a language' do
      subject.base_categories("uk").should be_kind_of(Array)
    end
  end
  describe '#search' do
    it 'returns list of categories' do
      subject.search('futurama').should be_kind_of(Array)
      subject.search('futurama').all?{|cat| cat.kind_of? ExUA::Category}
    end
    it 'returns 20 results by default' do
      subject.search('futurama').size.should eq(20)
    end
  end
end
