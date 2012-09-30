require 'spec_helper'

describe Unicafe::Lunch do

  let(:restaurant_id) {123}
  let(:lunches_mock) {[mock(Unicafe::Lunch)]}
  let(:restaurant_data) {example_menu_xml}
  let(:menu_uri) {"http://www.unicafe.fi/rss/fin/#{restaurant_id}/"}

  it "should fetch lunches according restaurant" do
    FakeWeb.register_uri(:get, menu_uri, body: restaurant_data)
    Unicafe::Lunch.should_receive(:parse_data).with(restaurant_data).and_return(lunches_mock)
    Unicafe::Lunch.lunches_for_restaurant(restaurant_id).should == lunches_mock
  end

  it "should parse lunches from XML" do
    parsed_data = mock(Feedzirra::Feed)
    Feedzirra::Feed.should_receive(:parse).with(restaurant_data).and_return(parsed_data)
    Unicafe::Lunch.should_receive(:format_data).with(parsed_data).and_return(lunches_mock)
    Unicafe::Lunch.parse_data(restaurant_data).should == lunches_mock
  end

end
