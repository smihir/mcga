from __future__ import division
__author__ = 'Sejal Chauhan'
__author_email__ = 'sejalc@cs.wisc.edu'
__version__ = '1.0'

import re
import sys
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

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

    def __init__(self, data1, data2):

        y1=[]
        y2=[]
        y3=[]
        
        splitLines = []
        pLargePg = 0
        count = 1
        
        for s in data1.split('\n'):
            try:
                x = re.findall("\d+", s)

                if len(x) > 0:
                    t1 = int(x[0])
                    t2 = t1 - int(x[1])
                    
                    # Find split instances 
                    if ( int(x[1]) == 0 ):
                        splitLines.append( count )

                    elif ( pLargePg / int(x[1]) ) > 2:
                        splitLines.append( count )
                    pLargePg = int(x[1])
                    count=count+1
                    
                    y1.append(t1)   # Total RSS
                    y2.append(t2)   # Total Small pages
            except ValueError:
                pass
        
        for x in splitLines:
            print x
        
        
        count = 1
        pLargePg = 0
        for s in data2.split('\n'):
            try:
                x = re.findall("\d+", s)
    
                if len(x) > 0:
                    t1 = int(x[0])
                                    
                    if count in splitLines:
                        pLargePg = t1

                    t1 = t1 - pLargePg
                    count = count + 1
                    
                    y3.append( t1 * 1024 * 2 ) # Total Large Page Promoted
            except ValueError:
                pass
       
        for i in range(0,len(y3)-1):
            y3[i] = y3[i] + y2[i]
        
        fig1 = plt.figure()
        x1 = np.arange(len(y1))
        ax1 = fig1.add_subplot(111)
        ax1.set_xlabel('Time (min)')
        ax1.set_ylabel('RSS (GB)')
        x1 = [x / 60 for x in x1]
        y1 = [y / 1048576 for y in y1]
        y2 = [y / 1048576 for y in y2]
        y3 = [y / 1048576 for y in y3]
       
        color1 = "#ffd699"
        color2 = "#ffb84d"
        #color3 = "#b30000"
        color3 = "#990000"
        ax1.plot(x1, y1, color=color1, label='Base Pages')
        ax1.plot(x1, y2, color=color3, label='Large Pages')
        ax1.plot(x1, y3, color=color2, label='Allocation Pages')
        
        ax1.fill_between(x1, 0, y1, facecolor = color1, interpolate=True)
        #ax1.fill_between(x1, 0, y3, facecolor = 'blue', interpolate=True)
        ax1.fill_between(x1, 0, y3, facecolor = color2, interpolate=True)
        ax1.fill_between(x1, 0, y2, facecolor = color3, interpolate=True)
        
        ax1.set_xlim([0, x1[-1]])
        ax1.set_ylim([0, 1.2* max(max(y1),max(y2))])
        
        yellow_patch = mpatches.Patch(color=color1 )
        orange_patch = mpatches.Patch(color=color3 )
        blue_patch = mpatches.Patch(color=color2 )
        
        #yellow_patch = mpatches.Patch(color='yellow', label ='Base Pages' )
        #orange_patch = mpatches.Patch(color='orange', label ='Large Pages')
        #plt.legend([yellow_patch, orange_patch], ["Memory backed by Base Pages", "Memory backed by Large Pages"], loc='upper left')
        plt.legend([yellow_patch, blue_patch, orange_patch], ["Allocation (Large Pages)","Promotion (Large Pages)", "Memory backed by Base Pages"], loc='upper left')
        plt.savefig("rssPlot.png")
        plt.show()

if __name__ == '__main__':
    with open(sys.argv[1], 'rb') as f1:
        data1 = f1.read()
        with open( sys.argv[2], 'rb') as f2:
            data2 = f2.read()
            rssvstime(data1, data2)
