import numpy as np

def hits(M, iter_num = 2):
	"""
	simple implementation of HITS algorithm
	"""
	N = len(M)
	hub = np.ones(N) * 1.
	auth = np.zeros(N)
	for _ in xrange(iter_num):
		auth = M.transpose().dot(hub)
		auth = np.array([a / auth.max() for a in auth])
		hub = M.dot(auth)
		# normalize
		hub = np.array([h / hub.max() for h in hub])		
		# print M
		print 'hub:', hub
		print 'auth:', auth
	return

if __name__ == '__main__':
	"""
	For week 7 advanced quiz question 3
	"""
	M = np.zeros([4, 4])
	edges = {1:[2, 3], 2:[1], 3:[4], 4:[3]}		
	for key in edges:		
		for v in edges[key]:
			M[key - 1, v - 1] = 1
	hits(M)
