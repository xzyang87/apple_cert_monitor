# AppleCertMonitor

[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/fastlane/fastlane/blob/master/LICENSE)
[![Gem](https://img.shields.io/gem/v/apple_cert_monitor.svg)](https://rubygems.org/gems/apple_cert_monitor)

This tool is the ruby-gem version of my last repo [apple-developer-account-client](https://github.com/xzyang87/apple-developer-account-client).

What AppleCertMonitor do is to monitor expiring/expired certificates/provising_profiles of all teams in an Apple developer account.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'apple_cert_monitor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install apple_cert_monitor
   
you may need run: `source ~/.bash_profile` or your own shell command language to take advantage of terminal's command prompt instantly.

## Usage
- pretty print all teams of an account on terminal

```ruby
$ apple_dev_client print_all_teams 
```
- print all expired/expiring certificates/provising_profiles separately on terminal and output **.txt** file to path: **~/Downloads/AppleCertMonitorOutput**

```ruby
$ check_certificates expired 
$ check_certificates expiring
$ check_provisioning_profiles expired
$ check_provisioning_profiles expiring
```
- also you can forget about remembering these commands and explore all the functionalities and usage-descriptions with just the head of the command:

```ruby
$ apple_dev_client
Commands:
	apple_dev_client help [COMMAND]   # Describe available commands or one specific command
  	apple_dev_client print_all_teams  # find and pretty-print all teams
  		
  	
$ check_certificates
Commands:
  	check_certificates expired         # find expired certificates in all teams
  	check_certificates expiring        # find expiring certificates in all teams
  	check_certificates help [COMMAND]  # Describe available commands or one specific command
  
$ check_provisioning_profiles
Commands:
  	check_provisioning_profiles expired         # find expired provisioning profiles in all teams
  	check_provisioning_profiles expiring        # find expiring provisioning profiles in all teams
  	check_provisioning_profiles help [COMMAND]  # Describe available commands or one specific command
```
and the UI and output txt file looks like this:

```ruby
================================================================================================================
Welcome to this cute tool. With its help, managing complicated Apple Developer Accounts have never been so easy!
=====================================================================
First, please enter Apple Developer Account info.
Enter Username:
XXXX@XXX.com
Enter Password:
Now login in, please wait......
************************************************************* 1 / 3 ******************************************************

* Now deal with team_id(XXXXXXXXXX) team_name(XXXXXXXXXX) team_type(Company/Organization)

*      =====================================================================
*      Now fetching certificates...
*      There are XX certificates in this team
*      Found 1 certificates with less than 60 days left.
*            --------------------------------------------------
*            No.    |  Certificate Name                 |  Days
*            --------------------------------------------------
*            1      |  com.xxx.xxxxxxx.xxxxxxxxxxxxxxx  |  22
*            --------------------------------------------------
************************************************************* 1 / 3 ******************************************************


********************************************** 2 / 3 ****************************************

* Now deal with team_id(XXXXXXXXXX) team_name(XXXXXXXXXX) team_type(In-House)

*      =====================================================================
*      Now fetching certificates...
*      There are XX certificates in this team
*      Found 8 certificates with less than 60 days left.
*            -------------------------------------------------
*            No.    |  Certificate Name                |  Days
*            -------------------------------------------------
*            1      |  com.xxxxxxx.xxx                 |  9
*            2      |  xxxxx xxxx                      |  0
*            3      |  xx xxxxxxxx                     |  0
*            4      |  xx xxxxxxxx                     |  0
*            5      |  xx xxxxxx                       |  0
*            6      |  xx xxxx                         |  9
*            7      |  xx xxxxxxxx                     |  27
*            8      |  com.xxxxxxx.xxxx.xxxxxxxx.xxxx  |  59
*            -------------------------------------------------
********************************************** 2 / 3 ****************************************


**************************************************** 3 / 3 **********************************************

* Now deal with team_id(XXXXXXXXXX) team_name(XXXXXXXXXX) team_type(Company/Organization)

*      =====================================================================
*      Now fetching certificates...
*      There are 10 certificates in this team
*      Found 0 certificates with less than 60 days left.
*      ---------------------------------------------------------------------
**************************************************** 3 / 3 **********************************************


File created at: 04/18/18 14:02
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/xzyang87/apple_cert_monitor](https://github.com/xzyang87/apple_cert_monitor). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
