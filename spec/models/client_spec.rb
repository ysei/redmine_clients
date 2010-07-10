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

  describe ".csv_import" do
    it "should create records from csv text" do
      expect {
      Client.csv_import(<<-CSV)
Lemon,01-2345-6789,98-7654-3210,100-0000,AAA,Lorem Ipsum
Apple,01-2345-6789,98-7654-3210,100-0000,BBB
Orange,01-2345-6789,98-7654-3210,100-0000,CCC,Lorem Ipsum
Bnana,123-456-7890,123-456-7891,200-0000,DDD
CSV
      }.to change(Client, :count).by(4)
    end

    context "when csv include duplicate data" do
      let(:invalid_csv) do
        <<-CSV
Lemon,01-2345-6789,98-7654-3210,100-0000,AAA,Lorem Ipsum
Orange,01-2345-6789,98-7654-3210,100-0000,BBB
Orange,01-2345-6789,98-7654-3210,100-0000,BBB
Bnana,123-456-7890,123-456-7891,200-0000,DDD
CSV
end
      it "should rollback" do
        expect {
          Client.csv_import(invalid_csv)
        }.to change(Client, :count).by(0)
      end

      it "should return false" do
        Client.csv_import(invalid_csv).should be_false
      end
    end
  end

  describe "#update_attributes" do
    context "when specify parent id" do
      let (:parent) { Factory(:client, :name => "Parent") }
      let (:child) { Factory(:client, :name => "Child") }

      before { child.update_attributes(:parent_id => parent.id) }

      it "should move to child of the parent" do
        child.parent.should == parent
      end
    end
  end
end
