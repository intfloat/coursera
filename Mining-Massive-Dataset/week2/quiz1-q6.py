# for LSH basic quiz question 6

def get(x, y):
	p1 = [0, 0]
	p2 = [100, 40]
	l1a = abs(x - p1[0]) + abs(y - p1[1])
	l1b = abs(x - p2[0]) + abs(y - p2[1])
	l2a = (x - p1[0])**2 + (y - p1[1])**2
	l2b = (x - p2[0])**2 + (y - p2[1])**2
	if l1a < l1b and l2a > l2b:
		print 'correct answer!'
	else:
		print 'incorrect answer'

get(53, 10)
get(61, 8)
get(58, 13)
get(66, 5)
