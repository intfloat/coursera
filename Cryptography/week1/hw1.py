cipher = '0x6c73d5240a948c86981bc294814d'
m0 = 'attack at dawn'
m1 = 'attack at dusk'
numc = eval(cipher)
num0 = int(m0.encode('hex'), 16)
num1 = int(m1.encode('hex'), 16)
res = numc^num0^num1
s = ''
print res
while res > 0:
    t = res%16
    if t>=10:
        s = str(chr(t+87))+s
    else:
        s = str(chr(t+48))+s
    res = res/16
print num0
print num1
print numc
print s
