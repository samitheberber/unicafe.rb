require 'spec_helper'

describe Unicafe::Lunch do

  let(:restaurant_id) {123}
  let(:lunch_mock) {mock(Unicafe::Lunch)}
  let(:lunches_mock) {[lunch_mock]}
  let(:restaurant_data) {example_menu_xml}
  let(:menu_uri) {"http://www.unicafe.fi/rss/fin/#{restaurant_id}/"}
  let(:parsed_data) {mock(Feedzirra::Feed)}
  let(:entry_mock) {mock(Feedzirra::Parser::RSSEntry)}
  let(:entries_mock) {[entry_mock]}

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
    date = mock(Date)
    summary = "foobar"
    lunches_html_mock = mock(Nokogiri::XML::Element)
    lunch_html_mock = mock(Nokogiri::XML::Element)
    entry_mock.should_receive(:title).and_return(title_text)
    entry_mock.should_receive(:summary).and_return(summary)
    Unicafe::Lunch.should_receive(:parse_date).with(title_text).and_return(date)
    Nokogiri::HTML::DocumentFragment.should_receive(:parse).with(summary).and_return(lunches_html_mock)
    lunches_html_mock.should_receive(:children).and_return([lunch_html_mock])
    Unicafe::Lunch.should_receive(:format_lunch).with(date, lunch_html_mock).and_return(lunch_mock)
    Unicafe::Lunch.format_lunches_of_date(entry_mock).should == lunches_mock
  end

end
