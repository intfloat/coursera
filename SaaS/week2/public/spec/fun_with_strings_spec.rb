require 'fun_with_strings'
require 'debugger'

describe 'palindrome detection' do
  it 'should work for simple strings' do
    'redivider'.should  be_a_palindrome
    'abracadabra'.should_not  be_a_palindrome
  end
  it 'should be case-insensitive' do
    'ReDivider'.should be_a_palindrome
  end
  it 'should ignore nonword characters' do
    'A man, a plan, a canal -- Panama'.should be_a_palindrome
    "Madam, I'm Adam!".should be_a_palindrome
  end    
end

describe 'word count' do
  it 'should return a hash' do
    'now is the time'.count_words.should be_a_kind_of Hash
  end
  it 'works on simple strings' do
    'Doo bee doo bee doo'.count_words.should ==
      {'doo' => 3, 'bee' => 2}
  end
  it 'ignores punctuation' do
    'A man, a plan, a canal -- Panama!'.count_words.should ==
      {'man' => 1, 'plan' => 1, 'canal' => 1, 'a' => 3, 'panama' => 1}
  end
  it 'works on the empty string' do
    ''.count_words.should ==  {}
  end
  it 'ignores leading whitespace' do
    "  toucan".count_words.should ==
      {'toucan' => 1 }
  end
  it 'ignores embedded whitespace' do
    "four   four  \n four \t four!".count_words.should ==
      {'four' => 4}
  end
end

describe 'anagram grouping' do
  describe 'sanity checks' do
    it 'should work on the empty string' do
      ''.anagram_groups.should == []
    end
    it 'should return an array of arrays for nonempty string' do
      'x'.anagram_groups.each { |element| element.should be_an Array }
    end
  end
  it 'for "scream cars for four scar creams"' do
    @anagrams =  'scream cars for four scar creams'.anagram_groups
    @anagrams.each { |group| group.sort! }
    [%w(cars scar), %w(four), %w(for), %w(creams scream)].each do |group|
        @anagrams.should include(group)
    end
  end
    
end
