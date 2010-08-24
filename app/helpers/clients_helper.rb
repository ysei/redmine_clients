# -*- coding: utf-8 -*-
module ClientsHelper
  def client_search_fields(selected = nil)
    options_for_select([['名称', 'name'],
                        ['住所', 'address'],
                        ['電話番号', 'phone'],
                        ['FAX番号', 'fax'],
                        ['担当者名', 'representative']
                       ], selected)
  end

  def client_options(client=nil)
    clients = Client.order_by_name.all.delete_if{|c| c == client }
    clients.collect {|c| [c.name, c.id] }
  end

  def project_options
    Project.all.collect{|c| [c.name, c.id] }
  end

  def client_name_from_root_with_link(client, sep=" » ")
    client.self_and_ancestors.collect {|c|
      if c == client
        h c.name
      else
        link_to c.name, client_path(c)
      end
    }.join(sep)
  end
end
