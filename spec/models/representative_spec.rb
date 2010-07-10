require 'spec_helper'

describe Representative do
  let(:client){ Factory(:client) }
  describe ".csv_import" do
    it "should create records from csv text" do
      expect {
        Representative.csv_import(<<-CSV)
John,Guitar,1234567890,1234567890,john@example.com,john@mobile.example.com,,#{client}
Paul,Bass,1234567890,1234567890,paul@example.com,paul@mobile.example.com,,#{client}
George,Guitar,1234567890,1234567890,george@example.com,george@mobile.example.com,,#{client}
Ringo,Drums,1234567890,1234567890,ringo@example.com,ringo@mobile.example.com,,#{client}
CSV
      }.to change(Representative, :count).by(4)
      client.should have(4).reps
    end

    context "when csv include unknown client name" do
      let(:invalid_csv) do
        <<-CSV
John,Guitar,1234567890,1234567890,john@example.com,john@mobile.example.com,,#{client}
Paul,Bass,1234567890,1234567890,paul@example.com,paul@mobile.example.com,,#{client}
George,Guitar,1234567890,1234567890,george@example.com,george@mobile.example.com,,crickets
Ringo,Drums,1234567890,1234567890,ringo@example.com,ringo@mobile.example.com,,#{client}
CSV
      end
      it "should rollback" do
        expect {
          Representative.csv_import(invalid_csv)
        }.to change(Representative, :count).by(0)
        client.should have(:no).reps
      end

      it "should return false" do
        Representative.csv_import(invalid_csv).should be_false
      end
    end
  end
end
