class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :text, :user
  belongs_to :user
  embedded_in :answer, :polymorphic => true, :inverse_of => :comments
  recursively_embeds_many

  field :text, :type => String

  accepts_nested_attributes_for :child_comments

  default_scope order_by([:created_at, :asc])

  validates_presence_of :text
  validates_associated :user
end
