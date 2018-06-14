require_relative '../lib/apple_cert_monitor.rb'

RSpec.describe AppleCertMonitor do
  let(:dummy_class) { Class.new { extend AppleCertMonitor } }
  let(:msg) { 'Just to print something...' }

  describe '.print_sth' do
    it 'should print to stdout' do
      expect { dummy_class.print_sth(msg) }.to output(msg).to_stdout
    end
  end
end
