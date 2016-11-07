require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @capacity = 8

    @length = 0
    @store = StaticArray.new(@capacity)
    @start_idx = 0
  end

  # O(1)
  def [](index)
    check_index index
    @store[(@start_idx + index) % @capacity]
  end

  # O(1)
  def []=(index, val)
    check_index index
    @store[(@start_idx + index) % @capacity] = val
  end

  # O(1)
  def pop
    check_index(0)

    val = self[@length - 1]
    @length -= 1

    val
  end

  # O(1) amortized
  def push(val)
    resize! if @length == @capacity

    @length += 1
    self[@length - 1] = val
  end

  # O(1)
  def shift
    check_index(0)

    val = self[0]

    @length -= 1
    @start_idx = (@start_idx + 1) % @capacity

    val
  end

  # O(1) amortized
  def unshift(val)
    resize! if @length == @capacity

    @length += 1
    @start_idx = (@start_idx - 1) % @capacity

    self[0] = val
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    raise Exception, "index out of bounds" unless index.between?(0, @length - 1)
  end

  def resize!
    new_store = StaticArray.new(@capacity * 2)

    @length.times do |i|
      new_store[i] = self[i]
    end

    @store = new_store
    @start_idx = 0
    @capacity *= 2
  end
end
