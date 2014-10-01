module Assembler

  class Assembler

    attr_accessor :bloom

    def initialize(size, count, k)
      @bloom = Bloom.new(size, count, k)
      @alphabet = ["A", "C", "G", "T"]
    end

    def load_fastq_file fastq
      # load a fastq file and store the kmers in the bloom filter
      file = File.open(fastq)
      name = file.readline
      seq = file.readline
      na = file.readline
      quals = file.readline
      count=0
      while name
        @bloom.add(seq)
        if count%10000==0
          print "."
        end
        name = file.readline rescue nil
        seq = file.readline rescue nil
        na = file.readline rescue nil
        quals = file.readline rescue nil
        count+=1
      end
      puts "Done loading #{fastq}"
    end

    def df_search(start, goal, path, total)
      if equals(start, goal)
        # puts "#{path}\t#{total}"
        return {:path => path, :total => total}
      else
        count = @bloom.get(start)
        best = 0
        bestpath = ""
        if count > 0
          @alphabet.each do |letter|
            ans = df_search("#{start[1..start.length]}#{letter}", goal, "#{path}#{letter}", total+count)
            if ans[:total] > best
              best = ans[:total]
              bestpath = ans[:path]
            end
          end
        end
        return {:path => bestpath, :total => best}
      end
    end

    def bf_search(start, goal)
      # start and goal are kmers
      # start is the last kmer of the left read
      # goal is the first kmer of the right read
      queue = []
      queue << {:kmer => start, :path => start, :total => 0}
      paths = []
      shortest = -1
      ticker=0
      while queue.size > 0
        kmer_hash = queue.shift
        kmer = kmer_hash[:kmer]
        if equals(kmer, goal)
          if shortest < 0
            shortest = kmer_hash[:path].length
          end
          if kmer_hash[:path].length <= shortest
            paths << {:path => kmer_hash[:path], :total => kmer_hash[:total]}
          end
        else
          count = @bloom.get(kmer)
          if count > 0 and (shortest<=0 or kmer_hash[:path].length <= shortest)
            # puts "#{kmer}\t#{count}"
            @alphabet.each do |letter|
              queue << {:kmer  => "#{kmer[1..kmer.length]}#{letter}",
                        :path  => "#{kmer_hash[:path]}#{letter}",
                        :total => kmer_hash[:total]+count}
            end
          end
        end
        if ticker%1_000_000==0
          puts kmer_hash[:path].length
        end
        ticker+=1
      end
      best = 0
      bestpath = ""
      paths.each do |p|
        if p[:total] > best
          best = p[:total]
          bestpath = p[:path]
        end
      end
      return bestpath
    end

    def equals(kmer1, kmer2)
      if kmer1 == kmer2
        return true
      elsif kmer1 == kmer2.tr("ACGT", "TGCA").reverse
        return true
      else
        return false
      end
    end

  end

end