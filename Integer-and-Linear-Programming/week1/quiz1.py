from cvxopt import matrix, solvers, spmatrix

cost = matrix([0.5, 0.9, 0.1, 0.6, 0.4])
nutrients = matrix([[53, 4.4, 0.4],
	                [40, 8, 3.6],
	                [12, 3, 2],
	                [53, 12, 0.9],
	                [6, 1.9, 0.3]], tc = 'd')

# print nutrients
mx = matrix([1000, 100, 100], tc = 'd')
mn = matrix([100, 10, 0], tc = 'd')

ID = spmatrix(1., range(5), range(5), (5, 5))
G = matrix([nutrients, -nutrients, -ID])
print G
H = matrix([mx, -mn, matrix([0] * 5)])
print H
sol = solvers.lp(cost, G, H)

print 'status:', sol['status']
print 'value for optimal solutions:', sol['x']
# print 'optimal value: ', sol['z']

a = 0.6
extra = [[0.5 * a] * 5, [0.9 * a] * 5, \
         [0.1 * a] * 5, [0.6 * a] * 5, \
         [0.4 * a] * 5]
for i in xrange(5):
	extra[i][i] -= cost[i]

G = matrix([G, -matrix(extra)])
H = matrix([H, matrix([0] * 5)])
sol = solvers.lp(cost, G, H)
print 'status:', sol['status']
print 'value for optimal solutions:', sol['x']

