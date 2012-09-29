require 'spec_helper'

describe Unicafe do

  let(:restaurant_name) {"example restaurant"}

  it "should be able to give specific restaurant" do
    restaurant_mock = mock(Unicafe::Restaurant)
    Unicafe::Restaurant.should_receive(:new).with(restaurant_name).and_return(restaurant_mock)

    Unicafe.get_restaurant(restaurant_name).should == restaurant_mock
  end

  it "should raise error if specific restaurant can't be found" do
    Unicafe::Restaurant.should_receive(:new).with(restaurant_name).and_raise(Unicafe::Restaurant::NotFound)
    expect{Unicafe.get_restaurant(restaurant_name)}.to raise_error(Unicafe::Restaurant::NotFound)
  end

end
