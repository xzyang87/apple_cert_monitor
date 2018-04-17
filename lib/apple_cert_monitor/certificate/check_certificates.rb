module AppleCertMonitor
  class CheckCertificates
    def self.expired
      # Get all the teams
      teams = AppleDevClient.teams

      # Loop every team
      teams.each_with_index do |team, team_index|
        # print team header
        AppleDevClient.print_team_header(team, team_index)

        # Set current_team_id manually
        Spaceship.client.team_id = team["teamId"]

        # find & print expired certificates
        cellModels = convert_certificates_to_table_cells(fetch_all_certificates)
        AppleDevClient.find_expired_items(cellModels,
                                          TableCellModel::MODEL_TYPES[:is_certificate])

        # print team footer
        AppleDevClient.print_team_footer(team, team_index)
      end
    end

    def self.expiring
      # Get all the teams
      teams = AppleDevClient.teams

      # Loop every team
      teams.each_with_index do |team, team_index|
        # print team header
        AppleDevClient.print_team_header(team, team_index)

        # Set current_team_id manually
        Spaceship.client.team_id = team["teamId"]

        # find & print 60 days to expire certificates
        cellModels = convert_certificates_to_table_cells(fetch_all_certificates)
        AppleDevClient.find_60_days_to_expire_items(cellModels,
                                                    TableCellModel::MODEL_TYPES[:is_certificate])

        # print team footer
        AppleDevClient.print_team_footer(team, team_index)
      end
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