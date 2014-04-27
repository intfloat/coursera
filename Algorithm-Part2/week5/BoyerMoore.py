# BoyerMoore.py
'''
(seed = 538620)
Suppose that you run the Boyer-Moore algorithm (using only the mismatched character heuristic)
to search for the pattern

         H E R I N T H 

in the text

         L E T U S C O L L E C T T H E M T O G E T H E R I N T H E M 

What is the sequence of characters in the text that is compared with the
last character in the pattern?
'''
p = 'EYUPONE'
s = 'EPASTTHEOLDSEESAWSYDNEYUPONEMI'
si = len(p) - 1
pos = [-1]*200

# calculate position array
for i in range(len(p)):
	pos[ord(p[i])] = i

# iterate for substring match
while si < len(s):
	ptr1 = si
	ptr2 = len(p)-1
	print 'character in s:', s[ptr1]
	while ptr2 >= 0:
		if s[ptr1]!=p[ptr2]:
			# no such character in pattern
			if pos[ord(s[ptr1])]<0:
				dx = ptr2+1
			else:
				dx = max(ptr2-pos[ord(s[ptr1])], 1)
			break
		else:
			ptr2 -= 1
			ptr1 -= 1
	if ptr2 < 0:
		print 'Match at position', si
		break
	else:
		# change position of next move
		si += dx
