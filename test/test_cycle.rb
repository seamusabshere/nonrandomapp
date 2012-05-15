require 'helper'

describe Cycle do
  before do
    $redis.flushall
  end
  it "starts from zero" do
    Cycle.new('test1').current.must_equal 0
    Cycle.new('test1').current.must_equal 1
    Cycle.new('test1').current.must_equal 2
  end
  it "restarts after it hits its size" do
    Cycle.new('test2', 'size' => 2).current.must_equal 0
    Cycle.new('test2', 'size' => 2).current.must_equal 1
    Cycle.new('test2', 'size' => 2).current.must_equal 0
    Cycle.new('test2', 'size' => 2).current.must_equal 1
  end
end
