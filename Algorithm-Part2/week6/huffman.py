
# calculate length of bits to represent a string,
# though Huffman tree can be built automatically,
# for this quiz, we build huffman tree by hand

h = {'H':4, 'R':4, 'Y':3, 'M':2, 'F':3, 'J':3, 'X':2}
s = 'RJXJFYMMXMXFJYJYMMMXXXFFYXJJFXMJXYFHRYJXFRYXFMHXXJXMMXXJXXMJMX'
result = 0
# simply accumulate bits for every single character
for ch in s:
	result += h[ch]
print 'Final result is:', result