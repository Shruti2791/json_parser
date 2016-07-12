class Json

  QUOTE = "\""
  OPEN_ARRAY = "["
  CLOSE_ARRAY = "]"
  OPEN_HASH = "{"
  CLOSE_HASH = "}"
  COLON = ":"
  COMMA = ","

  def initialize(string)
    @string = string
    @stack, @array_collection, @braces = [], [], []
    @hash_collection = {}
    @string_started = false
  end

  def parse
    @string.each_char do |char|
      handle_open_string(char)
      handle_close_string
      if char == OPEN_ARRAY
        handle_open_array(char)
      elsif char == OPEN_HASH
        handle_open_hash(char)
      elsif char == QUOTE
        handle_quotes(char)
      elsif char == COLON
        handle_colon(char)
      elsif char == COMMA
        handle_comma(char)
      elsif char == CLOSE_ARRAY
        handle_close_array(char)
      elsif char == CLOSE_HASH
        handle_close_hash(char)
      end
    end
    @stack.first.reverse
  end

  private

    def handle_open_array(char)
      push_in_braces_and_stack(char)
    end

    def handle_open_hash(char)
      push_in_braces_and_stack(char)
    end

    def handle_quotes(char)
      if !@string_started
        @string_started = true
        @new_string = ''
      else
        @new_string << char if (char != QUOTE)
        @string_started = false
        @string_closed = true
      end
    end

    def handle_open_string(char)
      if @string_started && char != QUOTE
        @new_string << char
      end
    end

    def handle_close_string
      if @string_closed
        @stack.push(@new_string)
        @new_string = ''
        @string_closed = false
      end
    end

    def handle_colon(char)
      @stack.push(char)
    end

    def handle_comma(char)
      if @braces.last == OPEN_ARRAY && @braces.length != 1
        @array_collection << @stack.pop
      elsif @braces.last == OPEN_HASH
        value = find_element_and_pop_string(COLON, @stack)
        @hash_collection[@stack.pop] = value
      end
    end

    def handle_close_array(char)
      @braces.pop
      new_array = []
      while (popped = @stack.pop) != OPEN_ARRAY
        new_array << popped
      end
      @stack.push(@array_collection + new_array)
      @array_collection = []
    end

    def handle_close_hash(char)
      @braces.pop
      new_hash = {}
      value = find_element_and_pop_string(COLON, @stack)
      new_hash[find_element_and_pop_string(OPEN_HASH, @stack)] = value
      @hash_collection.merge!(new_hash)
      @stack.push(@hash_collection)
      @hash_collection = {}
    end

    def find_element_and_pop_string(element, stack)
      while (popped_element = stack.pop) != element
        string = popped_element
      end
      string
    end

    def push_in_braces_and_stack(char)
      @braces << char
      @stack.push(char)
    end
end