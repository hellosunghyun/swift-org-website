# frozen_string_literal: true

# Automatically prepends site.baseurl to all internal absolute URLs
# in rendered HTML output. Fixes links when the site is served from
# a subdirectory (e.g., GitHub Pages project sites).
#
# Handles: href, src, action, poster attributes, CSS url() functions,
# and meta refresh redirects.
#
# Safe: skips protocol-relative URLs (//), fragment links (#),
# already-prefixed URLs, and external URLs (http/https).
# Idempotent: negative lookahead prevents double-prefixing.

module Jekyll
  module BaseurlRewriter
    def self.rewrite(output, baseurl)
      return output if baseurl.nil? || baseurl.empty? || output.nil?

      baseurl = baseurl.chomp('/')
      escaped = Regexp.escape(baseurl[1..])

      output = output.gsub(/((?:href|src|action|poster)=")\/(?!#{escaped}\/)([a-zA-Z])/) do
        "#{$1}#{baseurl}/#{$2}"
      end

      output = output.gsub(/(url\(["']?)\/(?!#{escaped}\/)([a-zA-Z])/) do
        "#{$1}#{baseurl}/#{$2}"
      end

      output = output.gsub(/(content="\d+;\s*url=)\/(?!#{escaped}\/)([a-zA-Z])/) do
        "#{$1}#{baseurl}/#{$2}"
      end

      output
    end
  end
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  baseurl = doc.site.config['baseurl']
  next if baseurl.nil? || baseurl.empty?
  next unless doc.output

  doc.output = Jekyll::BaseurlRewriter.rewrite(doc.output, baseurl)
end
