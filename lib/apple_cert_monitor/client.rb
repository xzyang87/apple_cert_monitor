require "spaceship"
require 'io/console'
# require './lib/model/table_cell_model'
require 'thor'
require 'apple_cert_monitor'
require 'apple_cert_monitor/consts'

module AppleCertMonitor
  class AppleDevClient < Thor

    desc "print_all_teams", "find and pretty-print all teams"
    def print_all_teams
      if Spaceship.client == nil
        puts "================================================================================================================".green
        puts "Welcome to this cute tool. With its help, managing complicated Apple Developer Accounts have never been so easy!".green
        puts "=====================================================================".green
        puts "First, please enter Apple Developer Account info."
        puts 'Enter Username:'
        username = STDIN.gets.strip
        password = STDIN.getpass("Enter Password:")
        puts "Now login in, please wait......".green
        AppleDevClient.login(username, password)
      end

      all_teams = Spaceship.client.teams

      if File.exists?(Consts::OUTPUT_FILE_NAME)
        File.delete(Consts::OUTPUT_FILE_NAME)
      end

      if all_teams.count <= 0
        puts "No teams available on the Developer Portal"
        puts "You must accept an invitation to a team for it to be available"
        puts "To learn more about teams and how to use them visit https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/ManagingYourTeam/ManagingYourTeam.html"
        raise "Your account is in no teams"
      else
        puts "=====================================================================".green
        puts "Multiple teams found on the " + "Developer Portal"
        AppleDevClient.pretty_print_teams(all_teams)
      end
    end

    def self.teams
      if Spaceship.client == nil
        puts "================================================================================================================".green
        puts "Welcome to this cute tool. With its help, managing complicated Apple Developer Accounts have never been so easy!".green
        puts "=====================================================================".green
        puts "First, please enter Apple Developer Account info."
        puts 'Enter Username:'
        username = STDIN.gets.strip
        password = STDIN.getpass("Enter Password:")
        puts "Now login in, please wait......".green
        AppleDevClient.login(username, password)
      end

      all_teams = Spaceship.client.teams
      return all_teams
    end

    def self.print_team_header(team, team_index)
      # configure stars line above
      stars_str = team_star_str(team, team_index)
      AppleDevClient.write_to_file_and_puts_to_console(stars_str)
      AppleDevClient.write_to_file_and_puts_to_console("\n")

      # configure output string for each team
      origin_str = team_header_str(team)
      AppleDevClient.write_to_file_and_puts_to_console(origin_str)
      AppleDevClient.write_to_file_and_puts_to_console("\n")
    end

    def self.print_team_footer(team, team_index)
      AppleDevClient.write_to_file_and_puts_to_console(team_star_str(team, team_index))
      AppleDevClient.write_to_file_and_puts_to_console("\n\n")
    end

    def self.team_star_str(team, team_index)
      # configure output string for each team
      origin_str = team_header_str(team)
      # configure stars line above
      star_index = 0
      stars_str = ''
      while star_index < origin_str.length
        if star_index == origin_str.length / 2
          progress_str = " #{team_index + 1} / #{teams.count} "
          stars_str += progress_str
          star_index += progress_str.length
        else
          stars_str += "*"
          star_index += 1
        end
      end

      return stars_str
    end

    def self.team_header_str(team)
      origin_str = "* " + "Now deal with team_id(" + team["teamId"] + ") team_name(" + team["name"] + ") team_type(" + team["type"] + ")"
      return origin_str
    end

    def self.find_expired_items(cellModels, model_type)
      find_items(cellModels, model_type)
    end

    def self.find_60_days_to_expire_items(cellModels, model_type)
      find_items(cellModels, model_type, 0, 60)
    end

    def self.write_to_file_and_puts_to_console(string)
      puts string
      if string.to_s.length > 0
        File.open(Consts::OUTPUT_FILE_NAME, 'a') {|f|
          f << string
        }
      end
    end

    def self.pretty_print_table(table_header_1, table_header_2, table_header_3, cellModels)
      if !cellModels.is_a?(Array)
        return
      end

      # configure index max length
      index_max_length = 5

      # configure longest name length
      longest_certificate_name_length = 0
      cellModels.each do |cell|
        if cell.kind_of?(TableCellModel)
          if cell.name.to_s.length > longest_certificate_name_length
            longest_certificate_name_length = cell.name.to_s.length
          end
        end
      end

      # configure underline
      underline_str = ''
      underline_index = index_max_length + "  |  ".length + longest_certificate_name_length + "  |  ".length + "Days".length
      while underline_index > 0
        underline_str += '-'
        underline_index -= 1
      end

      # top line
      table_top_line = "*            " + underline_str
      write_to_file_and_puts_to_console(table_top_line + "\n")

      # table title
      table_title = generate_formatted_table_row("*            ",
                                                 "No.",
                                                 "Certificate Name",
                                                 "Days",
                                                 index_max_length,
                                                 longest_certificate_name_length,
                                                 "  |  ")
      write_to_file_and_puts_to_console(table_title + "\n")

      # table title bottom line
      table_title_bottom_line = "*            " + underline_str
      write_to_file_and_puts_to_console(table_title_bottom_line + "\n")

      # table content
      cellModels.each_with_index do |cell, index|
        row_text = generate_formatted_table_row("*            ",
                                                (index + 1).to_s,
                                                cell.name.to_s,
                                                cell.days_to_now.to_s,
                                                index_max_length,
                                                longest_certificate_name_length,
                                                "  |  ")
        write_to_file_and_puts_to_console(row_text + "\n")
      end

      # table bottom line
      table_bottom_line = "*            " + underline_str
      write_to_file_and_puts_to_console(table_bottom_line + "\n")
    end

    def self.generate_formatted_table_row(left_margin, s1, s2, s3, max_s1_length, max_s2_length, separator)
      row_text = ""
      # concatenate index
      row_text += left_margin + s1.to_s
      i = 0
      while i < (max_s1_length - s1.to_s.length) do
        row_text += " "
        i += 1
      end

      row_text += separator

      # concantenate name
      row_text += s2
      i = 0
      while i < (max_s2_length - s2.to_s.length) do
        row_text += " "
        i += 1
      end

      row_text += separator

      # concantenate days
      row_text += s3

      return row_text
    end

    private

    # Login
    def self.login(username, password)
      Spaceship::Portal.login(username, password)
    end

    def self.pretty_print_teams(teams)
      index_max_length = 5

      # configure longest id length
      longest_team_id_length = 0
      teams.each do |team|
        if team['teamId'].length > longest_team_id_length
          longest_team_id_length = team['teamId'].length
        end
      end

      # configure longest name length
      longest_team_name_length = 0
      teams.each do |team|
        if team['name'].length > longest_team_name_length
          longest_team_name_length = team['name'].length
        end
      end

      # configure longest type length
      longest_team_type_length = 0
      teams.each do |team|
        if team['type'].length > longest_team_type_length
          longest_team_type_length = team['type'].length
        end
      end

      # configure underline
      underline_str = ''
      underline_index = index_max_length + "  |  ".length + longest_team_id_length + "  |  ".length + longest_team_name_length + "  |  ".length + longest_team_type_length + "  |  ".length
      while underline_index > 0
        underline_str += '-'
        underline_index -= 1
      end

      puts "*            " + underline_str
      printf "*            %-#{index_max_length}s  |  %-#{longest_team_id_length}s  |  %-#{longest_team_name_length}s  |  %-#{longest_team_type_length}s\n", "No.", "Team Id", "Team Name", "Team Type"
      puts "*            " + underline_str
      teams.each_with_index do |team, index|
        printf "*            %-#{index_max_length}s  |  %-#{longest_team_id_length}s  |  %-#{longest_team_name_length}s  |  %-#{longest_team_type_length}s\n", (index + 1).to_s, team['teamId'], team['name'], team['type']
      end
      puts "*            " + underline_str
    end

    def self.find_items(cellModels, model_type, days_left_min=-999999, days_left_max=0)
      target_items = []

      # find expired items
      cellModels.each do |item|
        if item.is_a?(TableCellModel) && item.days_to_now >= days_left_min && item.days_to_now < days_left_max
          target_items << item
        end
      end

      # configure title string
      title_str = model_type ==
          TableCellModel::MODEL_TYPES[:is_certificate] ?
                      ("*" + "      Found #{target_items.count} certificates with less than #{days_left_max} days." + "\n")
                      :
                      ("*" + "      Found #{target_items.count} provisioning profiles with less than #{days_left_max} days." + "\n")
      write_to_file_and_puts_to_console(title_str)

      # print out
      if target_items.count == 0
        write_to_file_and_puts_to_console("*      ---------------------------------------------------------------------\n")
      else
        # print table rows
        pretty_print_table("No.",
                           model_type == TableCellModel::MODEL_TYPES[:is_certificate] ? "Certificate Name" : "Provisioning Profile Name",
                           "Days",
                           target_items)
      end
    end
  end
end
