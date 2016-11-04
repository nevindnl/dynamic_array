require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
		@capacity = 8

		@store = StaticArray.new(@capacity)
		@length = 0
  end

  # O(1)
  def [](index)
		check_index(index)
		@store[index]
  end

  # O(1)
  def []=(index, value)
		check_index(index)
		@store[index] = value
  end

  # O(1)
  def pop
		check_index(0)

		val = self[@length - 1]
		@length -= 1

		val
  end

  # O(1) amortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
		resize! if @length == @capacity

		@length += 1
		self[@length - 1] = val
  end

  # O(n): has to shift over all the elements.
  def shift
		check_index(0)

		val = self[0]
		(@length - 1).times do |i|
			self[i] = self[i + 1]
		end
		@length -= 1

		val
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
		resize! if @length == @capacity

		@length += 1
		(@length - 1).downto(1).each do |i|
			self[i] = self[i - 1]
		end


		self[0] = val
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
		raise Exception, "index out of bounds" unless index.between?(0, @length - 1)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
		@capacity *= 2
		new_store = StaticArray.new(@capacity)

		@length.times do |i|
			new_store[i] = @store[i]
		end

		@store = new_store
  end
end
