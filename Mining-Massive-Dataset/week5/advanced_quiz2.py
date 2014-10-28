
bids = [.1, .09, .08, .07, .06]
ctr1 = [.015, .016, .017, .018, .019]
ctr2 = [.01, .012, .014, .015, .016]
ctr3 = [.005, .006, .007, .008, .010]
price1 = [i * j for i, j in zip(bids, ctr1)]
price2 = [i * j for i, j in zip(bids, ctr2)]
price3 = [i * j for i, j in zip(bids, ctr3)]
budget = [1, 2, 3, 4, 5]
number_of_advertiser = len(bids)
counter = [0] * number_of_advertiser

while sum(counter) < 101:
	visited = [False] * number_of_advertiser
	mx, pos = -1, -1	
	for i, p in enumerate(price1):
		if not visited[i] and budget[i] >= bids[i] and p > mx:
			mx, pos = p, i
	p1 = pos
	if pos >= 0 and sum(counter) < 101:
		visited[pos] = True
		budget[pos] -= bids[pos]
		counter[pos] += 1

	mx, pos = -1, -1	
	for i, p in enumerate(price2):
		if not visited[i] and budget[i] >= bids[i] and p > mx:
			mx, pos = p, i	
	if pos >= 0 and sum(counter) < 101:
		visited[pos] = True
		budget[pos] -= bids[pos]
		counter[pos] += (ctr2[pos] / ctr1[p1])

	mx, pos = -1, -1	
	for i, p in enumerate(price3):
		if not visited[i] and budget[i] >= bids[i] and p > mx:
			mx, pos = p, i
	if pos >= 0 and sum(counter) < 101:
		visited[pos] = True
		budget[pos] -= bids[pos]
		counter[pos] += (ctr3[pos] / ctr1[p1])

print 'result:', map(int, counter)
print 'sum:', sum(map(int, counter))
