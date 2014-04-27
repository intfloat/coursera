
pattern = 'CBCCBCCA'
dfa = []
for i in range(3):
	dfa.append([0]*len(pattern))

# calculate transition table for DFA
def solve():
	prev = 0
	a = ord('A')
	dfa[ord(pattern[0])-a][0] = 1
	for i in range(1, len(pattern)):
		for j in range(3):
			dfa[j][i] = dfa[j][prev]
		dfa[ord(pattern[i])-a][i] = i+1
		prev = dfa[ord(pattern[i])-a][prev]
	# print out corresponding result
	print ' '.join(map(str, range(len(pattern))))
	for j in range(3):
		print ' '.join(map(str, dfa[j]))

if __name__ == '__main__':
	solve()
