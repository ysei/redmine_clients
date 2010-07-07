# -*- coding: utf-8 -*-
require 'spec_helper'

describe Client do
  let (:client) { Factory(:client) }

  describe "#to_s" do
    it "is alias for name" do
      client.to_s.should == client.name
    end
  end

  describe "#name_from_root" do
    let (:child) { Factory(:client, :name => "Orange Lab", :parent_id => client.id) }
    let (:grandchild) { Factory(:client, :name => "Lemon House", :parent_id => child.id) }

    it "concatenate names from root" do
      grandchild.name_from_root.should == "#{client.name} » #{child.name} » #{grandchild.name}"
    end

    it "can specify a separator" do
      grandchild.name_from_root(' - ').should == "#{client.name} - #{child.name} - #{grandchild.name}"
    end
  end
end
