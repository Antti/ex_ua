require 'spec_helper'
require 'tempfile'

describe ExUA::Item, vcr: true do
  let(:id) {68579769}
  subject{ExUA::Item.new(id)}
  describe '#download' do
    let(:tmp_file) { Tempfile.new('foo')}
    let(:png_header) {[137, 80, 78, 71, 13, 10, 26, 10] }
    after(:each) do
      tmp_file.unlink
    end
    it 'returns content of a file' do
      subject.download[0..7].bytes.should eq png_header
    end
    it 'saves content to a file' do
      subject.download(tmp_file)
      tmp_file.read[0..7].bytes.should eq png_header
    end
  end
  its(:get_uri){should eq Addressable::URI.parse("http://www.ex.ua/get/#{id}")}
  its(:load_uri){should eq Addressable::URI.parse("http://www.ex.ua/load/#{id}")}
  describe '#retrieve_real_load_url'
  describe '#retrieve_real_get_url'
end
