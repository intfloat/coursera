import sys
from nltk.corpus import wordnet as wn 
from nltk import word_tokenize as wt 
from nltk.corpus import stopwords 
from nltk.corpus import wordnet_ic

single_out = None  
sw = stopwords.words('english') # import stopwords 
def each_file(filelist):
    global single_out
    try:
        inp = file(filelist, "r")
    except IOError:
        sys.stderr.write('Error: Cannot read input file %s' % filelist)
        sys.exit(1)
    line = inp.readline()
    brown_ic = wordnet_ic.ic("ic-brown.dat")
    while line:
        line = line.strip() # get input file path
        print 'processing '+line
        try:
            single = file(line, "r") # generate input file object
            single_out = file(line+".sim", "w")
        except IOError:
            sys.stderr.write("Error: Cannot read input file %s\n" % single)
            sys.exit(1)
        edus = [] # hold all edus in that input file
        l = single.readline()
        while l: # keep reading until the end of file
            ls = l.strip()
            edus.append(ls)
            l = single.readline()
        single_out.write(str(len(edus))+"\n")
        for i in range(0, len(edus)): # produce score for each pair
            for j in range(i+1, len(edus)):
                if i==j: 
                    continue
                # score for current pair of strings
                #print edus[i]
                #print edus[j]
                single_out.write(str(i)+" "+str(j)+"\n")
                print i,j
                scoreline(edus[i], edus[j], brown_ic)
        line = inp.readline() # continue processing next line
        single_out.flush()
 
def scoreline(line1,line2,ic): 
    global single_out
    global sw
    t1 = wt(line1) # tokenize line1 
    t2 = wt(line2) # tokenize line2 
    #print t1
    #print t2
    s1 = [wn.synsets(x) for x in t1 if x not in sw]
    s2 = [wn.synsets(x) for x in t2 if x not in sw]
    if len(s1)==0 or len(s2)==0:
        return 0
    syns1 = set(reduce(lambda x,y:x+y,s1)) # get set of synsets of line1 
    syns2 = set(reduce(lambda x,y:x+y,s2)) # get set of synsets of line2 
    res_runningscore = 0.0 
    path_runningscore = 0.0
    lin_runningscore = 0.0 
    wup_runningscore = 0.0 
    jcn_runningscore = 0.0
    res_mark = 0
    path_mark = 0
    wup_mark = 0
    jcn_mark = 0
    lin_mark =0
    runningcount = 0 
    #print "syns1: ", syns1 
    #print "syns2: ", syns2

    for syn1 in syns1: # get Wordnet similarity score 
        res_best = 0
        path_best = 0
        wup_best = 0
        jcn_best = 0
        lin_best = 0
        for syn2 in syns2: 
            if ic is not None: 
                try: 
                #print syn1.res_similarity(syn2, ic)
                    res_mark = syn1.res_similarity(syn2, ic) 
                except: res_mark = 0
                try:
                    path_mark = syn1.path_similarity(syn2)
                except: path_mark = 0
                try:
                    wup_mark = syn1.wup_similarity(syn2)
                except: wup_mark  = 0;
                try:
                    jcn_mark = syn1.jcn_similarity(syn2, ic)
                    if jcn_mark > 100:
                        jcn_mark = 5
                        #print "jcn_mark", jcn_mark
                except: jcn_mark = 0
                try:
                    lin_mark = syn1.lin_similarity(syn2, ic)
                except: lin_mark = 0
            res_best = max([res_best, res_mark])
            path_best = max([path_best, path_mark])
            wup_best = max([wup_best, wup_mark])
            jcn_best = max([jcn_best, jcn_mark])
            lin_best = max([lin_best, lin_mark])
            #if mark>best:
            #   best = mark
        #runningcount += 1 
        res_runningscore += res_best
        path_runningscore += path_best   
        wup_runningscore += wup_best
        jcn_runningscore += jcn_best   
        lin_runningscore += lin_best

    runningcount = min([len(syns1),len(syns2)])
    # need to consider if it is suitable to divide the length of first edu
    res_score = res_runningscore/runningcount
    path_score = path_runningscore/runningcount
    wup_score = wup_runningscore/runningcount 
    jcn_score = jcn_runningscore/runningcount 
    lin_score = lin_runningscore/runningcount 
    print res_score, path_score, wup_score, jcn_score, lin_score
    single_out.write(str(res_score)+" "+str(path_score)
            +" "+str(wup_score)+" "+str(jcn_score)
            +" "+str(lin_score)+"\n")
    return res_score # return overall scores 

if __name__ == "__main__":
    if len(sys.argv)!=2:
        print 'You should put two parameter containing file lists.'
        sys.exit(2)
    each_file(sys.argv[1]);

'''
print 'here'
#print "path_similarity "+str(scoreline("I am doing homework all.", "what a wonderful task.", wn.path_similarity))
#print "path_similarity "+str(scoreline("I am doing dog cat homework all.", "bad good", wn.path_similarity))

brown_ic = wordnet_ic.ic("ic-brown.dat")
#print "lch_similarity "+str(scoreline("I know about physics and chemistry.", "what a wonderful day.", wn.lch_similarity))
#print "wup_similarity "+str(scoreline("dog", "day", None))

print "res_similarity "+str(scoreline("cat", "day", brown_ic))
print "jcn_similarity "+str(scoreline("homework", "day", brown_ic))
print "lin_similarity "+str(scoreline("animal", "plant", brown_ic))'''
