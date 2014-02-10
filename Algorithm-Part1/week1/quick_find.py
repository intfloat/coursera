arr = range(10)
print 'original:', arr
for i in range(6):
    index = map(int, raw_input('please input two indices:').split())
    p = arr[index[0]]
    q = arr[index[1]]
    for j in range(len(arr)):
        if arr[j]==p:
            arr[j] = q
    print 'current: ', arr
print 'result:', arr
            
