module ClientsHelper
  def client_options(client=nil)
    clients = Client.all.delete_if{|c| c == client }
    clients.collect {|c| [c.name, c.id] }
  end

  def project_options
    Project.all.collect{|c| [c.name, c.id] }
  end
end
