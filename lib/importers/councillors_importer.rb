require 'importers/base_importer'

module Importers
  class CouncillorsImporter < BaseImporter
    def import!
      each_row do |row|
        councillor = Person.find_or_initialize_by(first_name: row[:first_name], last_name: row[:last_name])
        puts "Importing councillor: #{councillor.name}"
        councillor.job_level = 'councillor'
        councillor.councillor_code = row[:num_trans]
        councillor.personal_code = row[:identificador]
        councillor.councillor_order = row[:councillor_order]
        councillor.party = Party.find_by!(long_name: row[:party_long_name])
        councillor.email = "tmp@madrid.es"
        councillor.role = row[:post]
        councillor.secondary_role = row[:post_2]
        councillor.starting_date = Date.iso8601(row[:starting_date]) if row[:starting_date].present?
        councillor.leaving_date = Date.iso8601(row[:leaving_date]) if row[:leaving_date].present?
        councillor.previous_calendar_until = row[:previous_calendar_until]
        councillor.previous_calendar_url = row[:previous_calendar_url]
        councillor.admin_first_name = transliterate(row[:first_name]).upcase
        councillor.admin_last_name = transliterate(row[:last_name]).upcase
        councillor.save!
      end
    end
  end
end
