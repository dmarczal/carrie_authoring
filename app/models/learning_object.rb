class LearningObject
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name, :type => String
  field :description, :type => String

  slug :name

  references_many :exercises, :dependent => :delete
  references_many :introductions, :dependent => :delete

  validates_presence_of :name, :description
  validates_uniqueness_of :name

  def markdown_desc
    options = {:hard_wrap => true, :filter_html => true, :autolink => true,
               :no_intraemphasis => true, :fenced_code => true, :gh_blockcode => true}
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
    markdown.render(self.description).html_safe
  end
end
