# A Liquid tag for Jekyll sites that allows embedding Gists and showing code for non-JavaScript enabled browsers and readers.
# by: Brandon Tilly
# Source URL: https://gist.github.com/1027674
# Post http://brandontilley.com/2011/01/31/gist-tag-for-jekyll.html
#
# Example usage: {% gist 1027674 gist_tag.rb %} //embeds a gist for this plugin

require 'cgi'
require 'digest/md5'
require 'net/https'
require 'uri'

module Jekyll
  class GistItTag < Liquid::Tag
    def initialize(tag_name, text, token)
      super
      @text           = text
      @cache_disabled = false
      @cache_folder   = File.expand_path "../.gist-it-cache", File.dirname(__FILE__)
      FileUtils.mkdir_p @cache_folder
    end

    def render(context)
      if parts = @text.match(/(\h*) (.*)/)
        commit, path = parts[1].strip, parts[2].strip
        script_url   = script_url_for commit, path
        code         = get_cached_raw_file(commit, path) || get_raw_file_from_web(commit, path)
        html_output_for script_url, code
      else
        ""
      end
    end

    def html_output_for(script_url, code)
      code = CGI.escapeHTML code
      <<-HTML
<div><script src='#{script_url}'></script>
<noscript><pre><code>#{code}</code></pre></noscript></div>
      HTML
    end

    def script_url_for(commit, path)
      "http://gist-it.appspot.com/github/#{user}/#{repo}/raw/#{commit}/#{path}"
    end

    def user
      'whittle'
    end

    def repo
      'node-coffee-heroku-tutorial'
    end

    def get_cached_raw_file(commit, path)
      return nil if @cache_disabled
      cache_file = get_cache_file_for "#{commit}-#{path}"
      File.read cache_file if File.exist? cache_file
    end

    def get_cache_file_for(identifier)
      identifier = identifier.gsub '/', '-'
      bad_chars  = /[^a-zA-Z0-9\-_.]/
      identifier = identifier.gsub bad_chars, ''
      md5        = Digest::MD5.hexdigest "#{identifier}"
      File.join @cache_folder, "#{identifier}-#{md5}.cache"
    end

    def get_raw_file_from_web(commit, path)
      raw_uri           = get_raw_uri_for commit, path
      proxy             = ENV['http_proxy']
      if proxy
        proxy_uri       = URI.parse(proxy)
        https           = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port).new raw_uri.host, raw_uri.port
      else
        https           = Net::HTTP.new raw_uri.host, raw_uri.port
      end
      https.use_ssl     = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request           = Net::HTTP::Get.new raw_uri.request_uri
      data              = https.request request
      data              = data.body
      cache "#{commit}-#{path}", data unless @cache_disabled
      data
    end

    def get_raw_uri_for(commit, path)
      URI.parse "https://raw.github.com/#{user}/#{repo}/#{commit}/#{path}"
    end

    def cache(identifier, data)
      cache_file = get_cache_file_for identifier
      File.open(cache_file, "w") do |io|
        io.write data
      end
    end
  end

  class GistItTagNoCache < GistItTag
    def initialize(tag_name, text, token)
      super
      @cache_disabled = true
    end
  end
end

Liquid::Template.register_tag('gist_it', Jekyll::GistItTag)
Liquid::Template.register_tag('gist_it_no_cache', Jekyll::GistItTagNoCache)
