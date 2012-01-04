class Exercise
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title
  field :enunciation
  field :position, :type => Integer
  slug :title

  referenced_in :learning_object
  referenced_in :fractal

  embeds_many :questions

  validates_presence_of :fractal, :title, :enunciation
  validates_associated :fractal
  validates_associated :learning_object
  validates_uniqueness_of :title

  before_create :set_position

  def markdown_desc
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
    Redcarpet.new(self.enunciation, *options).to_html.html_safe
  end
private
  def set_position
    lo = learning_object.exercises.order_by([[ :position, :desc ]])
    if (lo.empty?)
      self.position= 1
    else
      self.position= lo.first.position + 1
    end
  end
end
