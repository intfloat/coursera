# LZW_compression.py

s = 'C A A A C A C A C B C B C B B'
arr = s.split()
h = {'A':41, 'B':42, 'C':43}
result = []

i = 0
cur = 81

# iterate for every character
while i < len(arr):
	t = arr[i]
	i += 1
	while h.has_key(t) and i<len(arr):
		t += arr[i]
		i += 1
	if i == len(arr):
		if h.has_key(t):
			result.append(h[t])
		else:
			result.append(h[t[:-1]])
			result.append(h[t[-1]])
		result.append(80)
		break
	else:
		result.append(h[t[:-1]])
		h[t] = cur
		cur += 1
		i -= 1

print 'hash table is:', h
print 'final result is:', ' '.join(map(str, result))