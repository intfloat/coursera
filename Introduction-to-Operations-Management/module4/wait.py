
from math import sqrt

# define a function to compute average time conveniently
def wait(activity, m, utilization, cva, cvp):
	return (activity * 1. / m) * (utilization**(sqrt(2 * (m + 1)) - 1) / (1 - utilization)) * ((cva**2 + cvp**2) / 2.)


# expect to get 0.137
print wait(4, 10, 0.8, .5, .25)	
print wait(100, 1, 35./36, 1, 1.2) / 60.
for i in xrange(6, 15):
	util = 12. / (3 * i)
	print i, wait(20, i, util, 2.5/5, 10/20.)