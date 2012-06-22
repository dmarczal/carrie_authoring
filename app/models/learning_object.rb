#encoding: utf-8
class LearningObject
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name, :type => String
  field :description, :type => String
  slug :name

  references_many :exercises, :dependent => :delete
  references_many :introductions, :dependent => :delete
  belongs_to :user

  has_and_belongs_to_many :learning_groups

  validates_presence_of :name, :description
  validates_uniqueness_of :name

  def markdown_desc
    options = {:hard_wrap => true, :filter_html => true, :autolink => true,
               :no_intraemphasis => true, :fenced_code => true, :gh_blockcode => true}
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
    markdown.render(self.description).html_safe
  end

  def pages
    intro = self.introductions.order_by([[ :position, :asc ]])
    exer = self.exercises.order_by([[ :position, :asc ]])
    pages = intro + exer
  end

  def pages_with_name
    c = 0;
    self.pages.map {|page| ["#{page.class.model_name.human} #{c+=1}: #{page.title}", c]}
  end

  def token_inputs
    { :id => _id, :name => name }
  end
end
