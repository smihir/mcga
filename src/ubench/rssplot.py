__author__ = 'Sejal Chauhan'
__author_email__ = 'sejalc@cs.wisc.edu'
__version__ = '1.0'

import re
import sys
import numpy as np
import matplotlib.pyplot as plt

class rssvstime:

    def __init__(self, data1):

        #thp enabled
        y1=[]
        x1 =[]
        #thp disabled
        y2=[]
        x2=[]
        value= "Transparent Huge Pages Disabled"
        enabled=1
        data = data1.split('\n')
        data2=[]
        for s in data:
            print s
            if (s == value) and not bool(re.search(r'\d', s)):
                enabled=0

            if(enabled==1):
                try:
                    x = re.findall("\d+", s)
                    if len(x)>0:
                        t = int(x[0])
                        r = int(x[2])
                        y1.append(r)
                        x1.append(t)
                except ValueError:
                    pass
            if(enabled==0):
                try:
                    x = re.findall("\d+", s)
                    if len(x)>0:
                        t = int(x[0])
                        r = int(x[2])
                        y2.append(r)
                        x2.append(t)
                except ValueError:
                    pass

        fig1 = plt.figure()
        ax1 = fig1.add_subplot(111)
        ax1.set_title("Resident Set Size v/s Time")
        ax1.set_xlabel('RSS in MB')
        ax1.set_ylabel('Time in ms')
        y1 = [x / 1000 for x in y1]
        y2 = [x / 1000 for x in y2]
        ax1.plot(x1,y1, c='r', label='THP enabled')
        ax1.plot(x2,y2, c='b', label='THP disabled')
        xlabels = ['128', '256', '512', '1024', '2048', '4096', '8192', '16384', '65536', '32768']
        ax1.set_xticklabels(xlabels, rotation='vertical')
        plt.xticks(x1, xlabels)
        ax1.plot(x1,y1, 'ro', x2, y2, 'gs')
        ax1.set_xscale('log', basex=2)
        legend = ax1.legend(loc='upper center', shadow=True)
        frame = legend.get_frame()
        plt.show()

if __name__ == '__main__':
    with open(sys.argv[1], 'rb') as f1:
        data1 = f1.read()
        rssvstime(data1)
