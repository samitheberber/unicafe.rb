require 'spec_helper'

describe Unicafe::Lunch do

  let(:restaurant_id) {123}
  let(:lunches_mock) {[mock(Unicafe::Lunch)]}
  let(:restaurant_data) {example_menu_xml}

  it "should fetch lunches according restaurant" do
    FakeWeb.register_uri(:get, "http://www.unicafe.fi/rss/fin/#{restaurant_id}/", body: restaurant_data, :content_type => 'application/xml')
    Unicafe::Lunch.should_receive(:parse_data).with(restaurant_data).and_return(lunches_mock)
    Unicafe::Lunch.lunches_for_restaurant(restaurant_id).should == lunches_mock
  end

end
