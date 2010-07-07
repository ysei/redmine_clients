class ClientProject < ActiveRecord::Base
  unloadable

  belongs_to :client
  belongs_to :project
end
