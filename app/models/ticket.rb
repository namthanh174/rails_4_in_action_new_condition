class Ticket < ActiveRecord::Base
  belongs_to :project
  belongs_to :author, class_name: "User"
  belongs_to :state
  validates :name, presence: true
  validates :description, presence: true, length: {minimum: 10}
  has_many :attachments, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tags, uniq: true
  
  before_create :assign_default_state
  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  attr_accessor :tag_names
  
  def tag_names=(names)
    @tag_names = names
    names.split.each do |name|
      self.tags << Tag.find_or_initialize_by(name: name)
    end
  end

  private
  def assign_default_state
    self.state ||= State.default
  end
end
