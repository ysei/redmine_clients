class Representative < ActiveRecord::Base
  unloadable

  validates_presence_of :name

  belongs_to :client
end
