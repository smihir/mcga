from __future__ import division
__author__ = 'Sejal Chauhan'
__author_email__ = 'sejalc@cs.wisc.edu'
__version__ = '1.0'

import re
import sys
import numpy as np
import matplotlib.pyplot as plt

# Usage of this script:
# python latencyplot.py <option #> <args>
# 1. Plots latency graph for both THP disabled(red) and enabled(green)
# Run the cmd: python latencyplot.py 1 <latencyThpDisabled.txt> <latencyThpEnabled.txt>
# 2. Plot the area curve of the base and large pages
# Input file format: <#Rss> <#Anon> format
# Run cmd: python latencyplot.py 2 <rssanon.txt>
# 3. Time taken to fork v/s RSS
# Run cmd: python latencyplot.py 3

class latencyboth:

    def __init__(self, data1, data2):

        y1=[]
        y2=[]

        for s1 in data1.split('\n'):
            try:
                x1 = re.findall("\d+", s1)
                if len(x1) > 0:
                    t = int(x1[0])
                    y1.append(t)
            except ValueError:
                pass
            
        for s2 in data2.split('\n'):
                try:
                    x2 = re.findall("\d+", s2)
                    if len(x2) > 0:
                        t = int(x2[0])
                        y2.append(t)
                except ValueError:
                    pass
        fig1 = plt.figure()
        x1 = np.arange(len(y1))
        x2 = np.arange(len(y2))
        ax1 = fig1.add_subplot(111)
        ax1.set_title("Latency time series")
        ax1.set_xlabel('Time (ms)')
        ax1.set_ylabel('Latency (ms)')
        rects1 = ax1.plot(x1, y1,color='r')
        rects2 = ax1.plot(x2, y2, color='g')
        frame1 = plt.gca()
        ax1.set_ylim([0, 200])
        ax1.set_xlim([0, min(len(x1),len(x2))])
        ax1.legend((rects1[0], rects2[0]), ('THP Disabled', 'THP Enabled'), shadow=False, loc='upper left')
        ax2 = plt.axes([.65, .6, .2, .2], axisbg='w')
        ax2.plot(x1, y1, color='r')
        ax2.plot(x2, y2, color='g')
        ax2.set_xlim([0, min(len(x1), len(x2))])
        plt.setp(ax2, xticks=[], yticks=[])
        plt.show()

class rssanon:
    def __init__(self, data1):

        y1=[]
        y2=[]
        for s in data1.split('\n'):
            for token in s.split():
                try:
                    x = re.findall("\d+", s)
                    if len(x) > 0:
                        t1 = int(x[0])
                        t2 = int(x[1])
                        y1.append(t1)
                        y2.append(t2)
                except ValueError:
                    pass

            fig1 = plt.figure()
            x2 = np.arange(len(y2))
            ax1 = fig1.add_subplot(111)
            ax1.set_title("Rss and AnonHugePages")
            ax1.set_xlabel('Time in s')
            ax1.set_ylabel('Rss and AnonHugePages')
            ax1.plot(x2, y1, color='r')
            ax1.plot(x2, y2, color='g')
            frame1 = plt.gca()
            frame1.axes.get_xaxis().set_visible(False)
            plt.show()

class forkplot:

    def __init__(self):
        
        y1 = [231, 400, 725, 1282, 2512]
        y2= [1263, 2427, 4881, 8589, 16973]
        x = np.arange(len(y1))
        fig1 = plt.figure()
        ax1 = fig1.add_subplot(111)
        ax1.set_title("Time taken to Fork v/s RSS")
        ax1.set_ylabel('Time in ms')
        ax1.set_xlabel('RSS')
        y1 = [y/1000 for y in y1]
        y2 = [y/1000 for y in y2]
        rects1 = ax1.plot(x, y1, color='r', marker='o')
        rects2 = ax1.plot(x, y2, color='g', marker='^')
        xlabel = ['128MB', '256MB', '512MB', '1GB', '2GB']
        plt.xticks(x, xlabel)
        ax1.set_xticklabels(xlabel, rotation='horizontal')
        ax1.legend((rects1[0], rects2[0]), ('THP Disabled', 'THP Enabled'), shadow=False, loc='upper left')
        plt.show()

if __name__ == '__main__':

        if sys.argv[1] == '1':
            with open(sys.argv[2], 'rb') as f1:
                data1 = f1.read()
            with open(sys.argv[3], 'rb') as f2:
                data2 = f2.read()
            latencyboth(data1, data2)
        if sys.argv[1] == '2':
            with open(sys.argv[2], 'rb') as f1:
                data1 = f1.read()
            rssanon(data1)
        if sys.argv[1] == '3':
            forkplot()
