# encoding: UTF-8

require 'spec_helper'

describe Unicafe::Lunch do

  let(:restaurant_id) {123}
  let(:lunch_mock) {mock(Unicafe::Lunch)}
  let(:lunches_mock) {[lunch_mock]}
  let(:restaurant_data) {example_menu_xml}
  let(:menu_uri) {"http://www.hyyravintolat.fi/rss/fin/#{restaurant_id}/"}
  let(:parsed_data) {mock(Feedzirra::Feed)}
  let(:entry_mock) {mock(Feedzirra::Parser::RSSEntry)}
  let(:entries_mock) {[entry_mock]}
  let(:date) {mock(Date)}
  let(:lunch_html_mock) {mock(Nokogiri::XML::Element)}
  let(:name) {"fish & chips (VL)"}
  let(:price) {"2.60"}
  let(:text_element_mock) {mock(Nokogiri::XML::Text)}
  let(:span_mock) {mock(Nokogiri::XML::Element)}
  let(:spans_mock) {[span_mock]}

  it "should fetch lunches according restaurant" do
    FakeWeb.register_uri(:get, menu_uri, body: restaurant_data)
    Unicafe::Lunch.should_receive(:parse_data).with(restaurant_data).and_return(lunches_mock)
    Unicafe::Lunch.lunches_for_restaurant(restaurant_id).should == lunches_mock
  end

  it "should parse lunches from XML" do
    Feedzirra::Feed.should_receive(:parse).with(restaurant_data).and_return(parsed_data)
    Unicafe::Lunch.should_receive(:format_data).with(parsed_data).and_return(lunches_mock)
    Unicafe::Lunch.parse_data(restaurant_data).should == lunches_mock
  end

  it "should format lunches from feed" do
    parsed_data.should_receive(:entries).and_return(entries_mock)
    Unicafe::Lunch.should_receive(:format_lunches_of_date).with(entry_mock).and_return(lunches_mock)
    Unicafe::Lunch.format_data(parsed_data).should == lunches_mock
  end

  it "should format lunches of day" do
    title_text = "foobar"
    summary = "foobar"
    lunches_html_mock = mock(Nokogiri::XML::Element)
    entry_mock.should_receive(:title).and_return(title_text)
    entry_mock.should_receive(:summary).and_return(summary)
    Unicafe::Lunch.should_receive(:parse_date).with(title_text).and_return(date)
    Nokogiri::HTML::DocumentFragment.should_receive(:parse).with(summary).and_return(lunches_html_mock)
    lunches_html_mock.should_receive(:children).and_return([lunch_html_mock])
    Unicafe::Lunch.should_receive(:format_lunch).with(date, lunch_html_mock).and_return(lunch_mock)
    Unicafe::Lunch.format_lunches_of_date(entry_mock).should == lunches_mock
  end

  it "should format lunch with date and data" do
    Unicafe::Lunch.should_receive(:format_name).with(lunch_html_mock).and_return(name)
    Unicafe::Lunch.should_receive(:format_price).with(lunch_html_mock).and_return(price)
    Unicafe::Lunch.should_receive(:new).with(name, price, date).and_return(lunch_mock)
    Unicafe::Lunch.format_lunch(date, lunch_html_mock).should == lunch_mock
  end

  it "should parse date" do
    date_string = "Maanantai 24.09.2012"
    Unicafe::Lunch.parse_date(date_string).to_s.should == "2012-09-24"
  end

  it "should format name" do
    lunch_html_mock.should_receive(:children).and_return(spans_mock)
    span_mock.should_receive(:name).and_return('span')
    span_mock.should_receive(:[]).with(:class).and_return('meal')
    span_mock.should_receive(:children).and_return([text_element_mock])
    text_element_mock.should_receive(:to_s).and_return(name)
    Unicafe::Lunch.format_name(lunch_html_mock).should == name
  end

  it "should format price" do
    price_string = "Edullisesti"
    price_parser = mock(Unicafe::PriceParser)
    lunch_html_mock.should_receive(:children).and_return(spans_mock)
    span_mock.should_receive(:name).and_return('span')
    span_mock.should_receive(:[]).with(:class).and_return('priceinfo')
    span_mock.should_receive(:children).and_return([text_element_mock])
    text_element_mock.should_receive(:to_s).and_return(price_string)
    Unicafe::PriceParser.should_receive(:new).and_return(price_parser)
    price_parser.should_receive(:parse).with(price_string).and_return(price)
    Unicafe::Lunch.format_price(lunch_html_mock).should == price
  end

  context "instance" do

    let!(:lunch) {Unicafe::Lunch.new(name, price, date)}

    it "should give name" do
      lunch.name.should == name
    end

    it "should give price" do
      lunch.price.should == price
    end

    it "should give date" do
      lunch.date.should == date
    end

  end

end
