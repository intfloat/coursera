import numpy as np

def topic_pagerank(M, S, beta = 0.7, iter_num = 20):
	N = len(M)
	rold = np.ones(N) * (1. / N)
	const = np.zeros(N)
	for key in S:
		const[key - 1] = S[key] * (1 - beta) / len(S)
	for _ in xrange(iter_num):
		print 'pagerank score vector:', rold
		rnew = M.dot(rold) * beta
		rnew += const		
		rold = rnew
	return rnew

if __name__ == '__main__':
	"""
	For week7 basic quiz, question 1
	"""
	M = np.zeros([4, 4])
	edges = {1:[2, 3], 2:[1], 3:[4], 4:[3]}
	# edges = [(1, 2), (2, 1), (1, 3), (3, 4), (4, 3)]
	seed = {1:(4./3), 2:(2./3)}
	# print edges
	for key in edges:		
		for v in edges[key]:
			M[v - 1, key - 1] = 1./len(edges[key])
	print 'pagerank matrix:', M
	print topic_pagerank(M, seed, beta = 0.7)