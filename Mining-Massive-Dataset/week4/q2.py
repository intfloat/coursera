import sys
from math import sqrt

def cosine(x, y):
	num = sum([i * j for (i, j) in zip(x, y)])
	xlen = sqrt(sum([i * i for i in x]))
	ylen = sqrt(sum([i * i for i in y]))
	res = num / (xlen * ylen)
	return res


matrix = [[1, 0, 1, 0, 1, 2],
          [1, 1, 0, 0, 1, 6],
          [0, 1, 0, 1, 0, 2]]

r = len(matrix)
c = len(matrix[0])
while True:
    alpha = float(sys.stdin.readline().strip())
    for i in range(r):
    	matrix[i][c - 1] *= alpha
    for i in range(r):
    	for j in range(i + 1, r):
    		print i, j, cosine(matrix[i], matrix[j])
    for i in range(r):
    	matrix[i][c - 1] /= alpha