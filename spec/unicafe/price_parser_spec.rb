# encoding: UTF-8

require 'spec_helper'

describe Unicafe::PriceParser do

  let!(:parser) {Unicafe::PriceParser.new}

  it "should replace maukkaasti with correct value" do
    parser.parse("Maukkaasti").should == Unicafe::PriceParser::MAUKKAASTI
  end

  it "should replace edullisesti with correct value" do
    parser.parse("Edullisesti").should == Unicafe::PriceParser::EDULLISESTI
  end

  it "should replace makeasti with one value" do
    parser.parse("Makeasti 1,20€").should == '1.20'
  end

  it "should replace makeasti with another value" do
    parser.parse("Makeasti 1,00€").should == '1.00'
  end

  it "should raise error when not supported value" do
    expect{parser.parse("Trololoo")}.to raise_error(Unicafe::PriceParser::PriceError)
  end

end
