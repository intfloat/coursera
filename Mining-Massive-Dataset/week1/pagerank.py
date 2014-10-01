
def pagerank(g, beta = 0.85, total = 3., iter = 5):
    N = len(g)
    # initial importance value
    prev = [total / N] * N
    cur = [0] * N
    out_degree = [0] * N
    for i in xrange(N):
        for j in xrange(N):
            if g[i][j] > 0:
                out_degree[j] += 1
    
    print 'initial value of pagerank:', prev
    for it in xrange(iter):

        for col in xrange(N):
            cols = sum([g[row][col] * 1. for row in xrange(N)])            
            # normalization
            for row in xrange(N):
                if cols == 0:
                    print 'error: ', [g[row][col] for row in xrange(N)]
                    g[row][col] = (1. / N) * total
                else:
                    g[row][col] = (g[row][col] * 1. / cols) * total

        for i in xrange(N):
            for j in xrange(N):
                if g[i][j] > 0:
                    cur[i] += beta * prev[j] / out_degree[j];
            cur[i] += (1 - beta) * (total / N);
        # prev = cur will lead to shallow copy problem
        t = sum(cur)
        # normalization
        prev = [(score / t) * total for score in cur]
        print 'score after', it + 1, 'iterations:', prev
        cur = [0] * N

    return

if __name__ == '__main__':
    V = 3
    g = [[0] * V for _ in xrange(V)]
    A = 0
    B = 1
    C = 2
    # construct graph
    g[B][A] = 1
    g[C][A] = 1
    g[A][C] = 1
    g[C][B] = 1
    # run pagerank
    pagerank(g, beta = 1., iter = 10)

