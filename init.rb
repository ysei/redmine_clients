# -*- coding: utf-8 -*-
require 'redmine'

Redmine::Plugin.register :redmine_clients do
  name 'Redmine Clients plugin'
  author 'Kawaguchi Masaya'
  description 'This is a plugin for Redmine'
  version '0.0.1'

  menu :top_menu, :clients, { :controller => 'clients', :action => 'index' }, :caption => "クライアント", :after => :projects, :if => lambda{ User.current.logged? }
end
