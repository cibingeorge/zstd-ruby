require "spec_helper"
require 'zstd-ruby'
require 'securerandom'

# Generate dictionay methods
# https://github.com/facebook/zstd#the-case-for-small-data-compression
# https://github.com/facebook/zstd/releases/tag/v1.1.3

RSpec.describe Zstd do
  describe 'compress_using_dict' do
    let(:user_json) do
      IO.read("#{__dir__}/user_springmt.json")
    end
    let(:dictionary) do
      IO.read("#{__dir__}/dictionary")
    end

    it 'should return dictionary id' do
      dict_id = Zstd.get_dict_id(dictionary)
      expect(dict_id).to eq(1096339042)
    end

    it 'should work' do
      compressed_using_dict = Zstd.compress_using_dict(user_json, dictionary)
      compressed = Zstd.compress(user_json)
      expect(compressed_using_dict.length).to be < compressed.length
      expect(user_json).to eq(Zstd.decompress_using_dict(compressed_using_dict, dictionary))
    end

    it 'should work with simple string' do
      compressed_using_dict = Zstd.compress_using_dict("abc", dictionary)
      expect("abc").to eq(Zstd.decompress_using_dict(compressed_using_dict, dictionary))
    end

    it 'should work with blank' do
      compressed_using_dict = Zstd.compress_using_dict("", dictionary)
      expect("").to eq(Zstd.decompress_using_dict(compressed_using_dict, dictionary))
    end

    it 'should support compression levels' do
      compressed_using_dict    = Zstd.compress_using_dict(user_json, dictionary)
      compressed_using_dict_10 = Zstd.compress_using_dict(user_json, dictionary, 10)
      expect(compressed_using_dict_10.length).to be < compressed_using_dict.length
    end
  end

end

