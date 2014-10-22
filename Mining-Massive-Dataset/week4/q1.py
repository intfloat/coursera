from numpy import mean

matrix = [[1, 2, 3, 4, 5],
          [2, 3, 2, 5, 3],
          [5, 5, 5, 3, 2]]

r = len(matrix)
c = len(matrix[0])
for i in range(r):
    mean_val = mean(matrix[i])
    for j in range(c):
    	matrix[i][j] -= mean_val

for i in range(c):
	mean_val = mean([matrix[j][i] for j in range(r)])
	for j in range(r):
		matrix[j][i] -= mean_val

for row in matrix:
	print row
