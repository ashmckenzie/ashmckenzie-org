require 'redcloth'

module RedCloth::Formatters::HTML

  def cbimage opts
    group, qualifier, image, link, title = opts[:text].split(/\|/)
    <<-EOS
<p class="image">
  <a href="/attachments/#{group}/#{link}" class="fresco" title="#{title}" data-fresco-group="#{group}#{qualifier}" data-fresco-caption="#{title}" rel="#{group}#{qualifier}">
    <img src="/attachments/#{group}/#{image}" title="#{title}" alt="#{title}">
    <span class="title">#{title}</span>
  </a>
</p>
EOS
  end
end
