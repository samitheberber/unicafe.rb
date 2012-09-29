require 'spec_helper'

describe Unicafe::Restaurant do

  let(:name) {"Example restaurant"}
  let(:id) {123}

  it "should find restaurant by name" do
    restaurant_mock = mock(Unicafe::Restaurant)
    Unicafe::Restaurant.should_receive(:name_to_id).with(name).and_return(id)
    Unicafe::Restaurant.should_receive(:find_by_id).with(id).and_return(restaurant_mock)
    Unicafe::Restaurant.find_by_name(name).should == restaurant_mock
  end

  it "should raise error if name isn't supported" do
    Unicafe::Restaurant.should_receive(:name_to_id).with(name).and_raise(Unicafe::Restaurant::NotFound)
    expect{Unicafe::Restaurant.find_by_name(name)}.to raise_error(Unicafe::Restaurant::NotFound)
  end

  describe "#name_to_id" do

    let(:exactum) { {id: 11, name: "Exactum"} }
    let(:chemicum) { {id: 10, name: "Chemicum"} }

    it "should give correct id for Exactum" do
      Unicafe::Restaurant.name_to_id(exactum[:name]).should == exactum[:id]
    end

    it "should give correct id for Chemicum" do
      Unicafe::Restaurant.name_to_id(chemicum[:name]).should == chemicum[:id]
    end

    it "should raise error when unknown name is given" do
      expect{ Unicafe::Restaurant.name_to_id("This restaurant doesn't exist") }.to raise_error(Unicafe::Restaurant::NotFound)
    end

  end

end
