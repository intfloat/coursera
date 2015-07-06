from sys import stdin
g = [[] for _ in xrange(201)]
target = [7,37,59,82,99,115,133,165,188,197]
for line in stdin:
    fs = line.strip().split()
    x = int(fs[0])
    for edge in fs[1:]:
        y, w = map(int, edge.split(','))
        g[x].append((y, w))
        g[y].append((x, w))
dis = [1000000] * 201
visited = [False] * 201
dis[1] = 0
for _ in xrange(200):
    mn, idx = 1000000, -1
    for i in xrange(1, 201):
        if not visited[i] and dis[i] < mn:
            mn, idx = dis[i], i
    assert(idx != -1)
    visited[idx] = True
    for (y, w) in g[idx]:
        dis[y] = min(dis[y], dis[idx] + w)
res = [str(dis[t]) for t in target]
print ','.join(res)

