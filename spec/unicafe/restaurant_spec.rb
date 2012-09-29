# encoding: UTF-8

require 'spec_helper'

describe Unicafe::Restaurant do

  let(:name) {"Example restaurant"}
  let(:id) {123}
  let(:restaurant_mock) {mock(Unicafe::Restaurant)}

  it "should find restaurant by name" do
    Unicafe::Restaurant.should_receive(:name_to_id).with(name).and_return(id)
    Unicafe::Restaurant.should_receive(:find_by_id).with(id).and_return(restaurant_mock)
    Unicafe::Restaurant.find_by_name(name).should == restaurant_mock
  end

  it "should raise error if name isn't supported" do
    Unicafe::Restaurant.should_receive(:name_to_id).with(name).and_raise(Unicafe::Restaurant::NotFound)
    expect{Unicafe::Restaurant.find_by_name(name)}.to raise_error(Unicafe::Restaurant::NotFound)
  end

  it "should give restaurant object with correct id" do
    Unicafe::Restaurant.should_receive(:new).with(id).and_return(restaurant_mock)
    Unicafe::Restaurant.find_by_id(id).should == restaurant_mock
  end

  describe "#name_to_id" do

    it "should give correct id for given restaurant" do
      Unicafe::Restaurant::LIST_OF_RESTAURANTS.each do |id, name|
        Unicafe::Restaurant.name_to_id(name).should == id
      end
    end

    it "should raise error when unknown name is given" do
      expect{ Unicafe::Restaurant.name_to_id("This restaurant doesn't exist") }.to raise_error(Unicafe::Restaurant::NotFound)
    end

  end

  describe Unicafe::Restaurant::LIST_OF_RESTAURANTS do

    def check_id_name_pairs id, name
      Unicafe::Restaurant::LIST_OF_RESTAURANTS[id].should == name
    end

    it "should contain all defined pairs" do
      [
        {id: 1, name: "Metsätalo"},
        {id: 2, name: "Olivia"},
        {id: 3, name: "Porthania"},
        {id: 4, name: "Päärakennus"},
        {id: 5, name: "Rotunda"},
        {id: 6, name: "Topelias"},
        {id: 7, name: "Valtiotiede"},
        {id: 8, name: "Ylioppilasaukio"},
        {id: 10, name: "Chemicum"},
        {id: 11, name: "Exactum"},
        {id: 12, name: "Physicum"},
        {id: 13, name: "Meilahti"},
        {id: 14, name: "Ruskeasuo"},
        {id: 15, name: "Soc & kom"},
        {id: 16, name: "Kookos"},
        {id: 17, name: "Valdemar"},
        {id: 18, name: "Biokeskus"},
        {id: 19, name: "Korona"},
        {id: 21, name: "Viikuna"},
      ].each do |hash|
        check_id_name_pairs hash[:id], hash[:name]
      end
    end

  end

end
