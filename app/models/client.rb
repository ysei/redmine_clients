# -*- coding: utf-8 -*-
class Client < ActiveRecord::Base
  unloadable

  acts_as_nested_set

  validates_presence_of   :name
  validates_uniqueness_of :name, :message => "同じ名前のクライアントが存在しています"

  has_many :representatives, :dependent => :destroy
  alias :reps :representatives

  has_many :client_projects, :dependent => :destroy
  has_many :projects, :through => :client_projects, :uniq => true

  before_save :store_new_parent
  after_save :move_to_new_parent
  undef parent_id=

  def to_s
    name
  end

  def name_from_root(sep=" » ")
    self_and_ancestors.collect(&:name).join(sep)
  end

  private
  def store_new_parent
    @move_to_new_parent_id = send("#{parent_column_name}_changed?") ? parent_id : false
    true # force callback to return true
  end

  def move_to_new_parent
    if @move_to_new_parent_id.nil?
      move_to_root
    elsif @move_to_new_parent_id
      move_to_child_of(@move_to_new_parent_id)
    end
  end
end
