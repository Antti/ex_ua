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
    it 'returns response with content-type' do
      subject.download.content_type.should eq('image/png')
    end
    it 'returns response with content of a file' do
      subject.download.body[0..7].bytes.to_a.should eq png_header
    end
    it 'saves content to a file' do
      subject.download(tmp_file)
      tmp_file.read[0..7].bytes.to_a.should eq png_header
    end
  end
  describe '#head' do
    it 'has content-type' do
      subject.head.content_type.should eq('image/png')
    end
    it 'has content-length' do
      subject.head.content_length.should_not be_nil
    end
  end
  its(:get_uri){should eq Addressable::URI.parse("http://www.ex.ua/get/#{id}")}
  its(:load_uri){should eq Addressable::URI.parse("http://www.ex.ua/load/#{id}")}
  describe '#retrieve_real_load_url'
  describe '#retrieve_real_get_url'
end
