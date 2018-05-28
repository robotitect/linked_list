class LinkedList
  attr_accessor :head

  # Creates a new LinkedList
  # @param +head+ The initial value for the head node, default +nil+.
  def initialize(head = nil)
    @head = Node.new(head)
  end

  # Iterates over each node in the LinkedList
  def each_node
    current_node = @head
    while(current_node)
      yield(current_node)
      current_node = current_node.next_node
    end
  end

  # Iterates over each node in the LinkedList, tracks index
  def each_node_with_index
    i = 0
    each_node do |node|
      yield(node, i)
      i += 1
    end
  end

  # Iterates over the data content of each node in LinkedList
  def each_node_data
    each_node { |node| yield(node.value) }
  end

  # Iterates over the data content of each node in LinkedList, tracks index
  def each_node_data_with_index
    each_node_with_index { |node, index| yield(node.value, index) }
  end

  # Provides the final node in the LinkedList
  # @return +node+ [Node] The final node in the LinkedList
  def tail
    each_node { |node| return node if node.next_node.nil? }
  end

  # Creates a node with the passed in value as data
  # and adds it to the end of the LinkedList.
  # @param +data+ The data to add.
  def append(data)
    tail.next_node = data
    return self
  end

  # Creates a node with the passed in value as data
  # and adds it to the start of the LinkedList.
  # @param +data+ The data to add.
  def prepend(data)
    # old_head = @head
    # @head = Node.new(data, old_head)
    @head = Node.new(data, @head)
  end

  # Provides the size of the LinkedList
  # @return +size+ The size of the LinkedList
  def size
    each_node_with_index { |node, i| return (i + 1) if node.next_node.nil? }
  end

  # Provides the node at the given index in the LinkedList.
  # @param +index+ The index to find the node at.
  # @return +node+ The node at the given index, +nil+ if none available.
  def at(index)
    each_node_with_index { |node, i| return node if i == index }
    return nil
  end

  def pop
    each_node do |node|
      if(node.next_node.next_node == nil)
        to_return = node.next_node
        node.next_node = nil
        return to_return
      end
    end
  end

  def contains?(value)
    if(value.is_a?(Node))
      each_node { |node| return true if node == value }
    else
      each_node_data { |node_data| return true if node_data == value }
    end
    false
  end

  def find(data)
    if(data.is_a?(Node))
      each_node_with_index { |node, i| return i if node == data}
    else
      each_node_data_with_index { |node_data, i| return i if data == node_data }
    end
    -1
  end

  def to_s
    to_return = ""
    each_node_data { |node_data| to_return += "( #{node_data} ) -> " }
    return to_return + "nil"
  end

  def insert_at(index, data)
    if(data.is_a?(Node))
      if(data.next_node.nil?)
        at(index - 1).next_node = Node.new(data.value, at(index))
      else
        at(index - 1).next_node = data
      end
    else
      at(index - 1).next_node = Node.new(data, at(index))
    end
    return self
  end

  def remove_at(index)
    at(index - 1).next_node = at(index + 1)
  end

  class Node
    attr_accessor :value, :next_node

    def initialize(data = nil, next_candidate = nil)
      @value = data
      self.next_node = next_candidate
    end

    def next_node=(next_candidate)
      if(next_candidate.nil? || next_candidate.is_a?(Node))
        @next_node = next_candidate
      else # IF next_candidate is not a Node already THEN wrap in a Node
        @next_node = Node.new(next_candidate)
      end
    end
  end
end
