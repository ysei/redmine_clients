class Representative < ActiveRecord::Base
  unloadable

  validates_presence_of :name
  validates_presence_of :client

  belongs_to :client

  def self.csv_import(csv)
    begin
      transaction do
        CSV.parse(csv, ',').each do |data|
          new.instance_eval do
            self.name, self.post, self.phone, self.mobile_phone, self.email, self.mobile_email, self.note, client_name = data
            self.client = Client.find_by_name(client_name)
            save!
          end
        end

        true
      end
    rescue ActiveRecord::RecordInvalid
      false
    end
  end

end
