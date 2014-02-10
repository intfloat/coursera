arr = range(10)
size = [1]*10
print 'original:', arr

# used to find root of a tree
def find(pos):
    while pos != arr[pos]:
        pos = arr[pos]
    return pos

for i in range(9):
    index = map(int, raw_input('please input two indices:').split())
    r1 = find(index[0])
    r2 = find(index[1])
    if size[r1] < size[r2]:
        arr[r1] = r2
        size[r2] += size[r1]
    else:
        arr[r2] = r1
        size[r1] += size[r2]
    print 'current root: ', arr
    print 'current size: ', size
print 'result:', arr
            
