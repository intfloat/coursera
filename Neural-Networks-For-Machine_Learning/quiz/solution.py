
from numpy import *

# used for solving quiz in lecture 13
w1 = -6.90675478
w2 = 0.40546511

def sigmoid(x):
	return 1./(1+exp(-x))

def q1():
	return sigmoid(w2)

if __name__ == "__main__":
	ans1 = q1()
	print 'answer for question 1:', ans1
	ans2 = ans1*0.5*0.5
	print 'answer for question 2:', ans2
	ans4 = exp(-w2)/(1+exp(-w2))
	print 'answer for question 4:', ans4
	w1 = 10.
	w2 = -4.
	ans5 = (sigmoid(w2)*0.5)/(0.5*0.5+0.5*sigmoid(w2))
	print 'answer for question 5:', ans5
	ans6 = (sigmoid(w1+w2)*0.5)/(0.5*sigmoid(w1+w2) + 0.5*sigmoid(w1))
	print 'answer for question 6:', ans6
