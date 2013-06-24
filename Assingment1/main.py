from os import listdir
from os.path import isfile, join

import mincemeat
import string
import re
import collections

def mapfn(filename, lines):
    import re  
    for line in lines:
        line_sp = line.split(':::')
        auths = line_sp[1].split('::')
        words = re.sub('[^A-Za-z0-9 ]+','',line_sp[2]).lower().split(" ")
        for auth in auths:
            for word in words:
                if len(word) > 2:
                    yield (auth, word)

def reducefn(auth, word):
    import collections
    dict_ = collections.Counter(word)
    result = sorted(dict_.iteritems(), key=lambda item: -item[1])
    return result
       
MY_PATH = 'C:\Users\Sergey\Documents\Online Courses\Coursera\Web Inteligence and Big Data\Assingment 1\hw3data\\' 

onlyfiles = [ f for f in listdir(MY_PATH) if isfile(join(MY_PATH,f)) ]

datasource = collections.defaultdict(list)

for filename in onlyfiles: 
    s = MY_PATH + filename
    datasource[s] = []
    f = open(s, 'r')
    for line in f.readlines():
        datasource[s].append(line)
    f.close()

s = mincemeat.Server()
s.datasource = datasource
s.mapfn = mapfn
s.reducefn = reducefn


f = open("workfile.txt",'w')
results = s.run_server(password="changeme")

for author in results:
    f.write(str(author) + ":\n")
    for word in results[author]:
        s1 = "\t {0}: {1}".format(word[0], word[1])
        f.write(s1)
    f.write("\n\n")

f.close()


