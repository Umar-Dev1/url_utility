# frozen_string_literal: true

require 'net/http'

class UrlUtility
  def count_unique_urls(urls = [])
    return 0 unless urls.is_a?(Array)

    urls.map { |url| normalize_url(url) }.compact.uniq.count
  end

  def count_unique_urls_per_top_level_domain(urls = [])
    return {} unless urls.is_a?(Array)

    urls.map { |url| top_level_domain(url) }.compact.tally
  end

  private

  URL_REGEX = %r{(http://www\.|https://www\.|http://|https://)?[a-z0-9]+([-.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?}.freeze

  def valid_url?(url)
    return false unless url.is_a?(String)

    url.match(URL_REGEX)
  end

  def normalize_url(url)
    return unless valid_url?(url)

    domain = URI.parse(url)
    path = normalize_path(domain.path)

    url = "#{domain.scheme.downcase}://#{domain.host.downcase}#{path}"
    url = URI.decode_www_form_component(url)
    url.insert(-1, '/') if url[-1] != '/'
    url
  end

  def normalize_path(path)
    path = path.tr('.', '').squeeze('/')
    return path unless path.split('%').count > 1

    path = path.split('%')
    path[-1] = path[-1].downcase
    path.join('%')
  end

  def top_level_domain(url)
    return unless valid_url?(url)

    "#{URI.parse(url).host.split('.')[-2]}.com"
  end
end
