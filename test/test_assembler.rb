require 'helper'

class TestAssembler < Test::Unit::TestCase

  context "Assembler" do

    setup do
      @assembler = Assembler::Assembler.new(100000, 3, 21)
    end

    should "load a fastq file into the bloom filter" do
      left = File.join(File.dirname(__FILE__), 'data', 'left.fq')
      right = File.join(File.dirname(__FILE__), 'data', 'right.fq')
      @assembler.load_fastq_file left
      @assembler.load_fastq_file right
    end

    # should "find a path from a to b with depth first search" do
    #   left = File.join(File.dirname(__FILE__), 'data', 'left.fq')
    #   right = File.join(File.dirname(__FILE__), 'data', 'right.fq')
    #   @assembler.load_fastq_file left
    #   @assembler.load_fastq_file right
    #   start = "CCTCTCAACATCATCCCTTGG"
    #   goal = "GAAGGTTATGCAGATAGCGTT"
    #   path = "CCTCTCAACATCATCCCTTGGAAGATTGGTGAAGAACAGACCAGAGTCGCCTTGAAGGAACT"
    #   path << "TGGAAAGTTTGTGGAGGCCTGTTTTAGCTTCATCAGCAGGGGAACGCCCCAACGCTATCTG"
    #   path << "CATAACCTTC"
    #   time = Benchmark.measure do
    #     ans = @assembler.df_search(start, goal, start,0)
    #     assert_equal path, ans[:path]
    #   end
    #   puts time
    # end

    should "find a path from a to b with breadth first search" do
      left = File.join(File.dirname(__FILE__), 'data', 'left.fq')
      right = File.join(File.dirname(__FILE__), 'data', 'right.fq')
      @assembler.load_fastq_file left
      @assembler.load_fastq_file right
      start = "CCTCTCAACATCATCCCTTGG"
      goal = "GAAGGTTATGCAGATAGCGTT"
      path = "CCTCTCAACATCATCCCTTGGAAGATTGGTGAAGAACAGACCAGAGTCGCCTTGAAGGAACT"
      path << "TGGAAAGTTTGTGGAGGCCTGTTTTAGCTTCATCAGCAGGGGAACGCCCCAACGCTATCTG"
      path << "CATAACCTTC"
      result = @assembler.bf_search(start, goal)
      puts result
      assert_equal path, result
    end
  end
end
