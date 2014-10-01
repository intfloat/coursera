

def is_prime(number):
    i = 2
    while i * i <= number:
        if number % i == 0:
            return False
        i += 1
    return True

def mapper(data):
    output = {}
    for number in data:
        for i in xrange(2, number + 1):
            if number % i == 0 and is_prime(i):
                if not i in output:
                    output[i] = [number]
                else:
                    output[i].append(number)
    return output

def reducer(data):
    output = []
    for key, val in data.items():
        output.append([key, sum(val)])
    return output

if __name__ == '__main__':
    data = [15, 21, 24, 30, 49]
    map_out = mapper(data)
    red_out = reducer(map_out)
    print 'result:', red_out

