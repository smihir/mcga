from __future__ import division
import re
import sys
import numpy as np
import math
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from pylab import *
from matplotlib import pyplot

SIZE = 14
MEDIUM_SIZE = 14
BIGGER_SIZE = 16

plt.rc('font', size=SIZE)                # controls default text sizes
plt.rc('axes', titlesize=SIZE)           # fontsize of the axes title
plt.rc('axes', labelsize=MEDIUM_SIZE)    # fontsize of the x and y labels
plt.rc('xtick', labelsize=SIZE)          # fontsize of the tick labels
plt.rc('ytick', labelsize=SIZE)          # fontsize of the tick labels
plt.rc('legend', fontsize=SIZE)          # legend fontsize
#plt.rc('figure', titlesize=BIGGER_SIZE)  # fontsize of the figure title

class rssvstime:

    def __init__(self, data1, fileName ):
      
        Lst = []
        for s in data1.split('\n'):
            if s.startswith(' ') or s == '':
                continue
            else:
                #Lst.append( math.log( ( int(s) / 1000 ), 2 ) )
                Lst.append( math.log( ( int(s)  ), 2 ) )
        Lst = np.asarray( Lst )
        Lst = sorted ( Lst )
        
        cdf = []
        i = 0
        x1 = []
        X = []
        for x in Lst:
            newLst = [] 
            if i > 0 and x == cdf[ -1 ][ 0 ]:
                freq = cdf[-1][1]
                del( cdf[-1] )
                newLst.append( x ) 
                newLst.append( freq + 1 )
                cdf.append( newLst ) 
                del( x1[-1] )
                x1.append( freq + 1 )
            else:
                newLst.append( x )
                newLst.append( 1 )
                cdf.append( newLst )
                X.append( x ) 
                x1.append( 1 ) 
            i=i+1
        '''
        for elem in cdf:
            #print elem[1]
            x1.append( elem[1] )
            X.append( elem[0] )
        '''
        sumi = sum( x1 )
        x1 = np.asarray( x1 ) 
        x1 = np.cumsum( x1 )
        yPt = []     
        for xi in x1: 
            yPt.append( float( xi * 100 / sumi ) )
       
        pyplot.plot(X , yPt )

        ax = plt.gca() # grab the current axis

        #pyplot.show()
        pyplot.savefig("Cdf.png")
        return

if __name__ == '__main__':
    fileName = sys.argv[1]
    with open(sys.argv[1], 'rb') as f1:
        data1 = f1.read()
        rssvstime( data1,fileName )
