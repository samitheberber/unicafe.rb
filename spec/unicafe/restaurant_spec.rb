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
      Unicafe::Restaurant::LIST_OF_RESTAURANTS.each do |id, r_hash|
        Unicafe::Restaurant.name_to_id(r_hash[:name]).should == id
      end
    end

    it "should raise error when unknown name is given" do
      expect{ Unicafe::Restaurant.name_to_id("This restaurant doesn't exist") }.to raise_error(Unicafe::Restaurant::NotFound)
    end

  end

  describe "list of restaurants" do

    def check_id_name_pairs id, name
      Unicafe::Restaurant::LIST_OF_RESTAURANTS[id].should == name
    end

    it "should contain all defined pairs" do
      [
        {id: 1, hash: {name: "Metsätalo"}},
        {id: 2, hash: {name: "Olivia"}},
        {id: 3, hash: {name: "Porthania"}},
        {id: 4, hash: {name: "Päärakennus"}},
        {id: 5, hash: {name: "Rotunda"}},
        {id: 6, hash: {name: "Topelias"}},
        {id: 7, hash: {name: "Valtiotiede"}},
        {id: 8, hash: {name: "Ylioppilasaukio"}},
        {id: 10, hash: {name: "Chemicum", latitude: 60.205108, longitude: 24.963357}},
        {id: 11, hash: {name: "Exactum"}},
        {id: 12, hash: {name: "Physicum"}},
        {id: 13, hash: {name: "Meilahti"}},
        {id: 14, hash: {name: "Ruskeasuo"}},
        {id: 15, hash: {name: "Soc & kom"}},
        {id: 16, hash: {name: "Kookos"}},
        {id: 17, hash: {name: "Valdemar"}},
        {id: 18, hash: {name: "Biokeskus"}},
        {id: 19, hash: {name: "Korona"}},
        {id: 21, hash: {name: "Viikuna"}},
      ].each do |hash|
        check_id_name_pairs hash[:id], hash[:hash]
      end
    end

  end

  context "instance" do

    let!(:restaurant) {Unicafe::Restaurant.new(id)}
    let(:lunches_mock) {[mock(Unicafe::Lunch)]}

    it "should have correct name" do
      Unicafe::Restaurant::LIST_OF_RESTAURANTS.should_receive(:[]).with(id).and_return(name)
      restaurant.name.should == name
    end

    it "should give lunches" do
      Unicafe::Lunch.should_receive(:lunches_for_restaurant).with(id).and_return(lunches_mock)
      restaurant.lunches.should == lunches_mock
    end

  end

end
