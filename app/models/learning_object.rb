class LearningObject
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name, :type => String
  field :description, :type => String

  slug :name

  references_many :exercises, :dependent => :delete

  validates_presence_of :name, :description
  validates_uniqueness_of :name

  def markdown_desc
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
    Redcarpet.new(self.description, *options).to_html.html_safe
  end
end
