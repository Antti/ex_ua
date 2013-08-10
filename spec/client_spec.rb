require 'spec_helper'
describe ExUA::Client do
  subject{described_class}
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
end
