require "spaceship"
require 'thor'
require 'apple_cert_monitor'
require 'apple_cert_monitor/client'
require 'apple_cert_monitor/model/table_cell_model'

module AppleCertMonitor
  class CheckCertificates < Thor

    desc "expired", "find expired certificates in all teams"
    def expired
      AppleDevClient.set_output_file_name("expired_certificates-#{DateTime.now.strftime("%m_%d_%H_%M")}.txt")

      # Get all the teams
      teams = AppleDevClient.teams

      # Loop every team
      teams.each_with_index do |team, team_index|
        # print team header
        AppleDevClient.print_team_header(team, team_index)

        # Set current_team_id manually
        Spaceship.client.team_id = team["teamId"]

        # find & print expired certificates
        cellModels = CheckCertificates.convert_certificates_to_table_cells(CheckCertificates.fetch_all_certificates)
        AppleDevClient.find_expired_items(cellModels,
                                          TableCellModel::MODEL_TYPES[:is_certificate])

        # print team footer
        AppleDevClient.print_team_footer(team, team_index)
      end

      AppleDevClient.write_to_file_and_puts_to_console("File created at: #{DateTime.now.strftime("%m/%d/%y %H:%M")}")
    end

    desc "expiring", "find expiring certificates in all teams"
    def expiring
      AppleDevClient.set_output_file_name("expiring_certificates-#{DateTime.now.strftime("%m_%d_%H_%M")}.txt")

      # Get all the teams
      teams = AppleDevClient.teams

      # Loop every team
      teams.each_with_index do |team, team_index|
        # print team header
        AppleDevClient.print_team_header(team, team_index)

        # Set current_team_id manually
        Spaceship.client.team_id = team["teamId"]

        # find & print 60 days to expire certificates
        cellModels = CheckCertificates.convert_certificates_to_table_cells(CheckCertificates.fetch_all_certificates)
        AppleDevClient.find_60_days_to_expire_items(cellModels,
                                                    TableCellModel::MODEL_TYPES[:is_certificate])

        # print team footer
        AppleDevClient.print_team_footer(team, team_index)
      end

      AppleDevClient.write_to_file_and_puts_to_console("File created at: #{DateTime.now.strftime("%m/%d/%y %H:%M")}")
    end

    private

    def self.convert_certificates_to_table_cells(certificates)
      cellModels = []
      certificates.each do |certificate|
        cell = TableCellModel.new
        cell.name = certificate.owner_name.to_s
        days_to_now = (certificate.expires.to_datetime - DateTime.now).to_i
        cell.days_to_now = days_to_now
        cellModels << cell
      end

      return cellModels
    end

    def self.fetch_all_certificates
      AppleDevClient.write_to_file_and_puts_to_console("*      =====================================================================\n")
      puts "*      Now fetching certificates...\n"

      all_certificates = Spaceship::Portal.certificate.all

      puts "*      There are #{all_certificates.count} certificates in this team\n"
      return all_certificates
    end
  end
end