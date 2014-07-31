module Assembler

  class Assembler

    attr_accessor :bloom

    def initialize(size, count, k)
      @bloom = Bloom.new(size, count, k)
    end

  end

end