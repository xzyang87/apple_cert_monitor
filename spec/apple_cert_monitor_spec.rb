require_relative '../lib/apple_cert_monitor.rb'

RSpec.describe AppleCertMonitor do
  let(:dummy_class) { Class.new { extend AppleCertMonitor } }

  describe ".print_sth" do
    it "should print to stdout" do
      expect { dummy_class.print_sth }.to output("Just to print something...").to_stdout
    end
  end
end
