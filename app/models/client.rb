# -*- coding: utf-8 -*-
require 'csv'

class Client < ActiveRecord::Base
  unloadable

  acts_as_nested_set

  validates_presence_of   :name
  validates_uniqueness_of :name, :message => "同じ名前のクライアントが存在しています"

  has_many :representatives, :dependent => :destroy
  alias :reps :representatives

  has_many :client_projects, :dependent => :destroy
  has_many :projects, :through => :client_projects, :uniq => true

  # Hack for old awesome nested set
  before_save :store_new_parent
  after_save :move_to_new_parent
  protected_attributes.delete("parent_id")
  undef parent_id=

  def to_s
    name
  end

  def name_from_root(sep=" » ")
    self_and_ancestors.collect(&:name).join(sep)
  end

  def self.csv_import(csv)
    begin
      transaction do
        CSV.parse(csv, ',').each do |data|
          new.instance_eval do
            self.name, self.phone, self.fax, self.postal, self.address, self.description = data
            save!
          end
        end

        true
      end
    rescue ActiveRecord::RecordInvalid
      false
    end
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
