import sys,traceback
import os
import string

maxn = 200 #maximum number of states
symbol = 2 #number of symbols ('0','1')
epssymbol = 2

'''g[s1][i][s2]=True if and only if there's an edge with symbol i from state s1 to s2
   i: 0 is '0', 1 is '1', 2 is epsilon
   For fixed state s1 and a symbol c, it is not necessary to exist s2 such that
   g[s1][c][s2]=True. If no such s2 exists, we deem that getting c at state s1 will
   make the Epsilon-NFA go into a non-final "dead" state and will directly make the 
  the string not accepted.'''

g = [[[False] * maxn for i in range(symbol+1)] for j in range(maxn)]

''' closure[s1][s2] is True if and only if s2 is in CL(s1)'''
closure = [[False]*maxn for i in range(maxn)]

'''nextpa[i]=i if the regular expression at position i is not '('
   nextpa[i]=j if the regular expression at position i is '(' and jth position holds the corresponding ')'
'''
nextpa = [0]*100

state = 0 #current number of states

#add edge from s1 to s2 with symbol c
def addEdge(s1,c,s2):
    global g
    g[s1][c][s2]=True

#increase the number of states of NFA by 1
def incCapacity():
    global state
    global g

    for i in range(state+1):
        for j in range(symbol+1):
            g[i][j][state]=False
            g[state][j][i]=False
    state = state + 1
    return state - 1

#unite two Epsilon-NFAs, with start state s1 and s2, final state t1 and t2, respectively
#return an array of length 2, where the first element is the start state of the combined NFA. the second being the final state 
def union(s1,t1,s2,t2):
    st=[0]*2

    #Please fill in the program here

  
    return st

#concatenation of two Epsilon-NFAs, with start state s1 and s2, final state t1 and t2, respectively
#return an array of length 2, where the first element is the start state of the combined NFA. the second being the final state 
def concat(s1,t1,s2,t2):
    st=[0]*2
    #Please fill in the program here

    return st

#Closure of a Epsilon-NFA, with start state s and final state t
#return an array of length 2, where the first element is the start state of the closure Epsilon-NFA. the second being the final state 
def clo(s,t):
    st=[0]*2
    #Please fill in the program here

    return st
    
#Calculate the closure: CL()
def calc_closure():
    global closure
    global symbol
    queue = [0]*maxn
    
    for i in range(state):
        for j in range(state):
            closure[i][j]=False
        #Breadth First Search
        head=-1
        tail=0
        queue[0]=i
        closure[i][i]=True
        while (head<tail):
            head=head+1
            j=queue[head]
            #search along epsilon edge
            for k in range(state):
                if ((not closure[i][k]) and (g[j][symbol][k])):
                    tail=tail+1
                    queue[tail]=k
                    closure[i][k]=True

'''parse a regular expression from position s to t, returning the corresponding 
   Epsilon-NFA. The array of length 2 contains the start state at the first position
   and the final state at the second position'''
def parse(re, s, t):
    #single symbol
    if (s==t):
        st=[0]*2
        st[0]=incCapacity()
        st[1]=incCapacity()
        #epsilon
        if (re[s]=='e'):
            addEdge(st[0],symbol,st[1])
        else:
            addEdge(st[0],string.atoi(re[s]),st[1])
        return st
    
    #(....)
    if ((re[s]=='(')and(re[t]==')')):
        if (nextpa[s]==t):
            return parse(re,s+1,t-1)
    
    #RE1+RE2
    i=s
    while (i<=t):
        i=nextpa[i]
        
        if ((i<=t)and(re[i]=='+')):
            st1=parse(re,s,i-1)
            st2=parse(re,i+1,t)
            st = union(st1[0],st1[1],st2[0],st2[1])
            return st
        i=i+1
        
    
    #RE1.RE2
    i=s
    while (i<=t):
        i=nextpa[i]
        
        if ((i<=t) and (re[i]=='.')):
            st1=parse(re,s,i-1)
            st2=parse(re,i+1,t)
            st = concat(st1[0],st1[1],st2[0],st2[1])
            return st
        i=i+1
    
    #(RE)*
    st1=parse(re,s,t-1)
    st=clo(st1[0],st1[1])
    return st

#calculate the corresponding ')' of '('
def calc_next(re):
    global nextpa
    nextpa=[0]*len(re)
    for i in range(len(re)):
        if (re[i]=='('):
            k=0
            j=i
            while (True):
                if (re[j]=='('):
                    k=k+1
                if (re[j]==')'):
                    k=k-1
                if (k==0):
                    break
                j=j+1
            nextpa[i]=j
        else:
            nextpa[i]=i

def test(cur, finalstate, level, length, num):
    global closure
    global g
    nextone = [False]*state
    if (level>=length):
        return cur[finalstate]
    if ((num&(1<<level))>0):
        c=1
    else:
        c=0
    for i in range(state):
        if (cur[i]):
            for j in range(state):
                if (g[i][c][j]):
                    for k in range(state):
                        nextone[k]=(nextone[k] or closure[j][k])
    
    empty=True #test if the state set is already empty
    for i in range(state):
        if (nextone[i]):
            empty=False
    if (empty):
        return False
    return test(nextone,finalstate,level+1,length,num)

def Start(filename):
    global state
    global g
    result=''
    #read data case line by line from file
    try:
        br=open(filename,'r')
        for re in br:
            print 'Processing '+re+'...'
            re=re.strip()
            calc_next(re)
            state=0
            nfa=parse(re,0,len(re)-1)
            #calculate closure
            calc_closure()
            #test 01 string of length up to 6
            for length in range(1,6+1):
                for num in range(0,(1<<length)):
                    if (test(closure[nfa[0]],nfa[1],0,length,num)):
                        for i in range(length):
                            if ((num&(1<<i))>0):
                                result=result+'1'
                            else:
                                result=result+'0'
                        result=result+"\n"
        #Close the input stream
        br.close()
    except:
        exc_type, exc_value, exc_traceback = sys.exc_info()
        print "*** print_exception:"
        traceback.print_exception(exc_type, exc_value, exc_traceback,limit=2, file=sys.stdout)
        result=result+'error'
    return result


def main(filepath):
    return Start('testRE.in')

if __name__ == '__main__':
    main(sys.argv[1])
