require 'test/unit'
require 'rubygems'
gem 'rails', '>= 1.2.6'
require 'active_support'
require File.dirname(__FILE__) + '/../lib/enum_fu'

class Vehicle
  include EnumFu
  acts_as_enum :vehicle_type, [:car, :bus, :starship, :unknown]
  
  def initialize
    @attributes = {}
  end
  
  def read_attribute(name)
    @attributes[name]
  end
  
  def write_attribute(name, value)
    @attributes[name] = value
  end
end

class EnumFuTest < Test::Unit::TestCase
  def setup
    @vehicle = Vehicle.new
  end
  
  def test_initially_nil
    assert_nil @vehicle.vehicle_type
  end
  
  def test_symbol_assignments
    @vehicle.vehicle_type = :starship
    assert_equal :starship, @vehicle.vehicle_type
    assert_equal 2, @vehicle.read_attribute('vehicle_type')
  end
  
  def test_string_value_assignments
    @vehicle.vehicle_type = 'starship'
    assert_equal :starship, @vehicle.vehicle_type
    assert_equal 2, @vehicle.read_attribute('vehicle_type')
  end
  
  def test_string_number_assignments
    @vehicle.vehicle_type = '2'
    assert_equal :starship, @vehicle.vehicle_type
    assert_equal 2, @vehicle.read_attribute('vehicle_type')
  end
  
  def test_integer_assignments
    @vehicle.vehicle_type = 2
    assert_equal :starship, @vehicle.vehicle_type
    assert_equal 2, @vehicle.read_attribute('vehicle_type')
  end
  
  def test_casting_symbol_to_integer
    assert_equal 0, Vehicle.vehicle_type(:car)
    assert_equal 1, Vehicle.vehicle_type(:bus)
    assert_equal 2, Vehicle.vehicle_type(:starship)
    assert_equal 3, Vehicle.vehicle_type(:unknown)
    assert_nil Vehicle.vehicle_type(:invalid)
  end
  
  def test_constant_array
    assert_equal 4, Vehicle::VEHICLE_TYPE.size
    [:car, :bus, :starship, :unknown].each do |enum|
      assert Vehicle::VEHICLE_TYPE.include?(enum)
    end
  end
  
  def test_constant_array_human
    assert_equal 4, Vehicle::VEHICLE_TYPE_HUMAN.size
    [:car, :bus, :starship, :unknown].each do |enum|
      assert Vehicle::VEHICLE_TYPE_HUMAN.include?([enum.to_s.humanize,enum])
    end
  end
  
  def test_constant_hash_values
    assert_equal 4, Vehicle::VEHICLE_TYPE_VALUES.size
    [:car, :bus, :starship, :unknown].each do |enum|
      enum_human = enum.to_s.humanize
      assert Vehicle::VEHICLE_TYPE_VALUES.has_key?(enum_human)
      assert_equal Vehicle::VEHICLE_TYPE_VALUES[enum_human], Vehicle.vehicle_type(enum)
    end
  end
end
