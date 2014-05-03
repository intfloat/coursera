
# LZW_expansion.py

s = '42 42 41 81 43 81 84 43 85 42 80'
arr = map(int, s.split())

# only three letters are used in this specific problem
h1 = {41:'A', 42:'B', 43:'C'}
h2 = {'A':41, 'B':42, 'C':43}
cur = 81
result = []

# iterate for every number in coded array
for number in arr:
	if number == 80:
		break
	result.append(h1[number])
	if len(result) == 1:
		continue
	t = result[-2] + result[-1][0]
	if h2.has_key(t):
		continue
	else:
		h2[t] = cur
		h1[cur] = t
		cur += 1

print h2
print 'Final result is:', ''.join(result)
