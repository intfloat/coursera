from math import sqrt

def euclidean(x, y):
	return sqrt((x[0] - y[0])**2 + (x[1] - y[1])**2)

points = [(1, 6), (3, 7), (4, 3), (7, 7), (8, 2), (9, 5)]
chosen = [(0, 0), (10, 10)]
for _ in range(5):
	pos, mx = -1, -1
	for i, p in enumerate(points):
		distance = min([euclidean(p, pc) for pc in chosen])
		if distance > mx:
			mx, pos = distance, i
	print 'choose:', points[pos]
	chosen.append(points[pos])
	del points[pos]
