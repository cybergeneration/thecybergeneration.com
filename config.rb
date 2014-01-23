require 'builder'

Time.zone = "America/New_York"

activate :blog do |blog|
  blog.prefix = "blog" 
  blog.sources = "posts/{year}-{month}-{day}-{title}.html"
  blog.layout = "blog/article"
end
=begin

activate :blog do |blog|
  blog.prefix = "blog"
  blog.permalink = "{year}/{month}/{day}/{title}.html"
  blog.sources = "posts/{year}-{month}-{day}-{title}.html"
  blog.taglink = "tags/{tag}.html"
  blog.layout = "article"
  blog.summary_separator = /(READMORE)/
  blog.summary_length = 250
  blog.year_link = "{year}.html"
  blog.month_link = "{year}/{month}.html"
  blog.day_link = "{year}/{month}/{day}.html"
  blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  blog.calendar_template = "blog.html"

  blog.paginate = true
  blog.per_page = 10
  blog.page_link = "page/{num}"
end
=end

module Middleman::Blog::BlogArticle
  def summary
    data['summary']
  end
  def image
    data['image']
  end
  def author
    data['author']
  end
end

helpers do
  def nav_link(link_text, url, options={})
    options[:class] ||= ""
    options[:class] << " active" if url == current_page.url
    link_to(link_text, url, options)
  end

  def nav_active(page)
    @page_id == page ? {:class => "active"} : {}
  end

  def tag_links(tags)
    tags.map do |tag|
      link_to tag_path(tag), class: 'tag' do
        "#{tag} (#{tag_count(tag)})"
      end
    end.join('<br>')
  end

  def tag_count(tag)
    blog.articles.select { |article| article.tags.include?(tag) }.size
  end
end
set :markdown_engine, :redcarpet
set :markdown, :layout_engine => :haml, :fenced_code_blocks => true, :smartypants => true
activate :syntax
activate :asset_hash, ignore: /images/
page "/sitemap.xml", layout: false
page "/atom.xml", layout: false

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :haml, remove_whitespace: true

configure :development do
  activate :relative_assets
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash, ignore: /images/
  activate :relative_assets
end
