require 'helper'

class TestAssembler < Test::Unit::TestCase

  context "Bloom" do

    setup do
      size = 100000
      count = 3
      @k = 21
      @bloom = Assembler::Bloom.new(size, count, @k)
    end

    should "add a read to the bloom filter" do
      read = "ATACAACAGGCTAAACGTTCTTAACTAGGGGCGCAGACCTCAATACTGGTTCCCGAGTTGAAT"
      read << "CGGCGGCTTCCCCATTCTGAAGACTCATCGCGGAAAG" # random read with 100 b
      assert_equal 0, @bloom.add(read)
    end

    should "check existence of kmers" do
      read = "ATACAACAGGCTAAACGTTCTTAACTAGGGGCGCAGACCTCAATACTGGTTCCCGAGTTGAAT"
      read << "CGGCGGCTTCCCCATTCTGAAGACTCATCGCGGAAAG" # random read with 100 b
      assert_equal 0, @bloom.add(read)
      (0..79).each do |i|
        kmer = read[i...i+@k]
        assert_equal 1, @bloom.get(kmer)
      end
      assert_equal 0, @bloom.get("AAAAAAAAAAAAAAAAAAAAA")
    end


  end
end
