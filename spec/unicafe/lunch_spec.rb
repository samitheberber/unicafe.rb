require 'spec_helper'

describe Unicafe::Lunch do

  let(:restaurant_id) {123}
  let(:lunches_mock) {[mock(Unicafe::Lunch)]}

  it "should fetch lunches according restaurant" do
    restaurant_data = "foobar"
    FakeWeb.register_uri(:get, "http://www.unicafe.fi/rss/fin/#{restaurant_id}/", body: restaurant_data)
    Unicafe::Lunch.should_receive(:parse_data).with(restaurant_data).and_return(lunches_mock)
    Unicafe::Lunch.lunches_for_restaurant(restaurant_id).should == lunches_mock
  end

end
