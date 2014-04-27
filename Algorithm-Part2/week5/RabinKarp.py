# RabinKarp.py
'''
(seed = 757872)
What is the Rabin-Karp hash function of text[3..10] over the decimal alphabet with R = 10
and using the modulus Q = 167?

       j      0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 
    --------------------------------------------------------------------
    text[j]   4  3  6  3  6  ?  ?  ?  3  5  4  4  7  0  9  2  5  1  6  5  

The digits labeled with a ? are suppressed. Assume that the hash function of text[2..9]
is 22 and that you have precomputed 10000000 (mod 167) = 40.
'''
ans1 = 22
Q = 167
print 'result is:', ((ans1 - 6*40) * 10 + 4 + 10*Q)%Q