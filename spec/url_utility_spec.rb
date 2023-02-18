# frozen_string_literal: true

require 'rspec'
require 'url_utility'

describe UrlUtility do
  let(:subject) { described_class.new }

  describe '#count_unique_urls' do
    context 'with correct input' do
      it 'returns the uniq normalized urls count' do
        expect(subject.count_unique_urls(['https://example.com'])).to eq(1)
        expect(subject.count_unique_urls(['https://example.com', 'http://example.com'])).to eq(2)
        expect(subject.count_unique_urls(['https://example.com', 'https://example.com/'])).to eq(1)
        expect(subject.count_unique_urls(['https://example.com', 'https://example.com?'])).to eq(1)
        expect(subject.count_unique_urls(['http://example.com:80/', 'http://example.com/'])).to eq(1)
        expect(subject.count_unique_urls(['http://example.com/%7Efoo', 'http://example.com/~foo'])).to eq(1)
        expect(subject.count_unique_urls(['http://example.com/foo%2a', 'http://example.com/foo%2A'])).to eq(1)
        expect(subject.count_unique_urls(['HTTP://User@Example.COM/Foo', 'http://User@example.com/Foo'])).to eq(1)
        expect(subject.count_unique_urls(
                 ['http://example.com/foo/./bar/../qux', 'http://example.com/foo/bar/qux']
               )).to eq(1)
      end
    end

    context 'with incorrect input' do
      it 'returns zero' do
        expect(subject.count_unique_urls([])).to eq(0)
        expect(subject.count_unique_urls(nil)).to eq(0)
        expect(subject.count_unique_urls(['http://com'])).to eq(0)
        expect(subject.count_unique_urls([123])).to eq(0)
      end
    end
  end

  describe '#count_unique_urls_per_top_level_domain' do
    context 'with correct input' do
      it 'returns count for uniq top level domains' do
        expect(subject.count_unique_urls_per_top_level_domain(['https://example.com'])).to eq({ 'example.com' => 1 })
        expect(subject.count_unique_urls_per_top_level_domain(
                 ['https://example.com', 'https://subdomain.example.com']
               )).to eq({ 'example.com' => 2 })
      end
    end

    context 'with incorrect input' do
      it 'returns empty hash' do
        expect(subject.count_unique_urls_per_top_level_domain([])).to eq({})
        expect(subject.count_unique_urls_per_top_level_domain(nil)).to eq({})
        expect(subject.count_unique_urls_per_top_level_domain(['http://com'])).to eq({})
        expect(subject.count_unique_urls_per_top_level_domain([123])).to eq({})
      end
    end
  end
end
