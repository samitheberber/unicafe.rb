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
        {id: 1, hash: {name: "Metsätalo", latitude: 60.172577, longitude: 24.948878}},
        {id: 2, hash: {name: "Olivia", latitude: 60.175077, longitude: 24.952979}},
        {id: 3, hash: {name: "Porthania", latitude: 60.169878, longitude: 24.948669}},
        {id: 4, hash: {name: "Päärakennus", latitude: 60.169178, longitude: 24.949297}},
        {id: 5, hash: {name: "Rotunda", latitude: 60.170332, longitude: 24.950791}},
        {id: 6, hash: {name: "Topelias", latitude: 60.171806, longitude: 24.95067}},
        {id: 7, hash: {name: "Valtiotiede", latitude: 60.173897, longitude: 24.953095}},
        {id: 8, hash: {name: "Ylioppilasaukio", latitude: 60.169092, longitude: 24.93992}},
        {id: 10, hash: {name: "Chemicum", latitude: 60.205108, longitude: 24.963357}},
        {id: 11, hash: {name: "Exactum", latitude: 60.20509, longitude: 24.961209}},
        {id: 12, hash: {name: "Physicum", latitude: 60.204755, longitude: 24.963200}},
        {id: 13, hash: {name: "Meilahti", latitude: 60.190212, longitude: 24.908911}},
        {id: 14, hash: {name: "Ruskeasuo", latitude: 60.206341, longitude: 24.895871}},
        {id: 15, hash: {name: "Soc & kom", latitude: 60.173054, longitude: 24.95049}},
        {id: 16, hash: {name: "Kookos", latitude: 60.181034, longitude: 24.958652}},
        {id: 18, hash: {name: "Biokeskus", latitude: 60.226922, longitude: 25.013707}},
        {id: 19, hash: {name: "Korona", latitude: 60.226922, longitude: 25.013707}},
        {id: 21, hash: {name: "Viikuna", latitude: 60.23049, longitude: 25.020544}},
      ].each do |hash|
        check_id_name_pairs hash[:id], hash[:hash]
      end
    end

  end

  context "instance" do

    let!(:restaurant) {Unicafe::Restaurant.new(id)}
    let(:lunches_mock) {[mock(Unicafe::Lunch)]}
    let(:latitude) {1.234}
    let(:longitude) {1.234}
    let(:hash) {{name: name, latitude: latitude, longitude: longitude}}

    it "should have correct name" do
      Unicafe::Restaurant::LIST_OF_RESTAURANTS.should_receive(:[]).with(id).and_return(hash)
      restaurant.name.should == name
    end

    it "should give lunches" do
      Unicafe::Lunch.should_receive(:lunches_for_restaurant).with(id).and_return(lunches_mock)
      restaurant.lunches.should == lunches_mock
    end

    it "should give latitude" do
      Unicafe::Restaurant::LIST_OF_RESTAURANTS.should_receive(:[]).with(id).and_return(hash)
      restaurant.latitude.should == latitude
    end

    it "should give longitude" do
      Unicafe::Restaurant::LIST_OF_RESTAURANTS.should_receive(:[]).with(id).and_return(hash)
      restaurant.longitude.should == longitude
    end

  end

  context "geocoding" do
    let(:latitude) {60.170331}
    let(:longitude) {24.950792}
    let(:distances) {Unicafe::Restaurant.distances(latitude, longitude)}

    it "nearest should return restaurant with nearest location" do
      restaurant = Unicafe::Restaurant.nearest(latitude, longitude)
      restaurant.name.should == Unicafe::Restaurant.find_by_id(5).name
    end

    it "distances should return distances in km to each restaurant" do
      expected = [
        {name: "Metsätalo", distance: 0.27125381125240583},
        {name: "Olivia", distance: 0.5414153313784997},
        {name: "Porthania", distance: 0.12777370135136118},
        {name: "Päärakennus", distance: 0.15256172402068655},
        {name: "Rotunda", distance: 0.0001241918351063598},
        {name: "Topelias", distance: 0.16415126635849975},
        {name: "Valtiotiede", distance: 0.4164770966419465},
        {name: "Ylioppilasaukio", distance: 0.6169317693546285},
        {name: "Chemicum", distance: 3.9289156775382},
        {name: "Exactum", distance: 3.907689767961844},
        {name: "Physicum", distance: 3.8887487128635665},
        {name: "Meilahti", distance: 3.2015412019032445},
        {name: "Ruskeasuo", distance: 5.025012642110712},
        {name: "Soc & kom", distance: 0.3032441555908767},
        {name: "Kookos", distance: 1.2670140935623735},
        {name: "Biokeskus", distance: 7.189295780001909},
        {name: "Korona", distance: 7.189295780001909},
        {name: "Viikuna", distance: 7.720428952517577},
      ]

      distances.each do |dist, restaurant|
        expected.each do |ex|
          if ex[:name] == restaurant.name
            ex[:distance].should == dist
          end
        end
      end
    end
  end
end
