
from math import sqrt
from numpy import mean

def euclidean(x, y):
	return sqrt((x[0] - y[0])**2 + (x[1] - y[1])**2)

def kmeans(centroids, points):
	"""
	Only perform two iterations of k-means for this quiz
	"""
	iter_number = 2	
	while iter_number > 0:
		iter_number -= 1
		res = [[] for _ in  range(len(centroids))]
		for p in points:
			mn = 10**9
			pos = -1
			for i, c in enumerate(centroids):
				if euclidean(p, c) < mn:
					pos = i
					mn = euclidean(p, c)
			assert(pos >= 0)
			# print pos, len(res)
			res[pos].append(p)
		print 'allocation:', res
		for i, cl in enumerate(res):
			xc = mean([x for (x, _) in cl])
			yc = mean([y for (_, y) in cl])
			centroids[i] = (xc, yc)
		print 'new centroids:', centroids

	pass

if __name__ == '__main__':
	points = [(28, 145), (65, 140), (50, 130), (25, 125), (38, 115), (55, 118), \
	          (44, 105), (29, 97), (50, 90), (63, 88), (43, 83), (35, 63), (55, 63), \
	          (50, 60), (42, 57), (23, 40), (64, 37), (50, 30), (33, 22), (55, 20)]	

	centroids = [(25, 125), (44, 105), (29, 97), (35, 63), (55, 63), (42, 57), \
	             (23, 40), (33, 22), (55, 20), (64, 37)]
	# print len(points)
	assert(len(centroids) == 10)
	kmeans(centroids, points)
	pass
