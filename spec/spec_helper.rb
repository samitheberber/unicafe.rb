require 'rspec'
require 'fakeweb'
require 'unicafe'

FakeWeb.allow_net_connect = false

FIXTURES = File.dirname(File.expand_path(__FILE__)) + "/fixtures"

def example_menu_xml
  File.read("#{FIXTURES}/example_menu.xml")
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.before(:each) do
    FakeWeb.clean_registry
  end
end
