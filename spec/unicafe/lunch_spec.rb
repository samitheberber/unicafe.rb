require 'spec_helper'

describe Unicafe::Lunch do

  let(:restaurant_id) {123}
  let(:lunches_mock) {[mock(Unicafe::Lunch)]}
  let(:restaurant_data) {example_menu_xml}
  let(:menu_uri) {"http://www.unicafe.fi/rss/fin/#{restaurant_id}/"}

  it "should fetch lunches according restaurant" do
    Feedzirra::Feed.should_receive(:fetch_and_parse).with(menu_uri).and_return(restaurant_data)
    Unicafe::Lunch.should_receive(:format_data).with(restaurant_data).and_return(lunches_mock)
    Unicafe::Lunch.lunches_for_restaurant(restaurant_id).should == lunches_mock
  end

end
