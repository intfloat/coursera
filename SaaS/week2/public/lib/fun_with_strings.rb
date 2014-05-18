
module FunWithStrings
  
  def palindrome?
    # your code here
    gsub!(/\W/, '')
    self.downcase == self.reverse.downcase
  end

  def count_words
    # your code here
    arr = self.strip.split
    h = Hash.new(0)
    arr.each do  |s| 
      s.gsub!(/\W/, '')
      s.downcase!
      if s.length > 0
        h[s] = h[s] + 1
      end
    end
    h
  end

  def anagram_groups
    # your code here
    words = self.strip.split    
    h = Hash.new
    words.each do |s|
      t = s.downcase.chars.sort.join
      # print t + "\n"
      if h.has_key? t
        h[t] = h[t].push s
      else
        h[t] = [s]
      end
    end
    h.values
  end

end

# make all the above functions available as instance methods on Strings:

class String
  include FunWithStrings
end

print "this is a good day".anagram_groups
print "\n"