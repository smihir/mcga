from __future__ import division
__author__ = 'Sejal Chauhan'
__author_email__ = 'sejalc@cs.wisc.edu'
__version__ = '1.0'

import re
import sys
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

# Usage of this script:
# python latencyplot.py <option #> <args>
# 1. Plots latency graph for both THP disabled(red) and enabled(green)
# Run the cmd: python latencyplot.py 1 <latencyThpDisabled.txt> <latencyThpEnabled.txt>
# 2. Plot the area curve of the base and large pages
# Input file format: <#Rss> <#Anon> format
# Run cmd: python latencyplot.py 2 <rssanon.txt>
# 3. Time taken to fork v/s RSS
# Run cmd: python latencyplot.py 3

SIZE = 14
MEDIUM_SIZE = 14
BIGGER_SIZE = 16

plt.rc('font', size=SIZE)                # controls default text sizes
plt.rc('axes', titlesize=SIZE)           # fontsize of the axes title
plt.rc('axes', labelsize=MEDIUM_SIZE)    # fontsize of the x and y labels
plt.rc('xtick', labelsize=SIZE)          # fontsize of the tick labels
plt.rc('ytick', labelsize=SIZE)          # fontsize of the tick labels
plt.rc('legend', fontsize=SIZE)          # legend fontsize
plt.rc('figure', titlesize=BIGGER_SIZE)  # fontsize of the figure title

class latencyboth:

    def __init__(self, data1, data2):

        y1=[]
        y2=[]
        t1 = 0
        t2 = 0

        for s1 in data1.split('\n'):
            try:
                x1 = re.findall("\d+", s1)
                if len(x1) <= 2:
                    t1 += 1
                if len(x1) > 5:
                    t = int(x1[0])
                    y1.append(t)
            except ValueError:
                pass

        for s2 in data2.split('\n'):
                try:
                    x2 = re.findall("\d+", s2)
                    if len(x2) <= 2:
                        t2 += 1
                    if len(x2) > 5:
                        t = int(x2[0])
                        y2.append(t)
                except ValueError:
                    pass
        print t1, t2
        time = min(t1, t2)
        print time
        print len(y1), len(y2)
        fig1 = plt.figure()
        x1 = np.arange(start=0, stop=t1, step=t1/len(y1))
        x2 = np.arange(start=0, stop=t2, step=t2/len(y2))
        ax1 = fig1.add_subplot(111)
        ax1.set_xlabel('Time (s)')
        ax1.set_ylabel('Null-GET Request Latency (ms)')
        rects1 = ax1.plot(x1, y1,color='r')
        rects2 = ax1.plot(x2, y2, color='g')
        ax1.set_ylim([0, max(y1) + 10])
        ax1.set_xlim([0, time])
        ax1.legend((rects1[0], rects2[0]), ('THP Disabled', 'THP Enabled'), shadow=False, loc='upper left')
        ax2 = plt.axes([.65, .6, .2, .2], axisbg='w')
        #ax2.plot(x1, y1, color='r')
        #ax2.plot(x2, y2, color='g')
        #ax2.set_xlim([0, min(len(x1), len(x2))])
        #plt.setp(ax2, xticks=[], yticks=[])
        ax2.plot(x1, y1, color='r', linewidth=2)
        ax2.plot(x2, y2, color='g', linewidth=2)
        ax2.set_xlim([0, time])
        for label in (ax2.get_xticklabels() + ax2.get_yticklabels()):
            label.set_fontsize(12) # Size here overrides font_prop
        ax2.xaxis.set_ticks([0, 350])
        ax2.yaxis.set_ticks([700,1400])
        plt.show()

class rssanon:
    def __init__(self, data1):

        y1=[]
        y2=[]
        for s in data1.split('\n'):

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
        x1 = np.arange(len(y1))
        ax1 = fig1.add_subplot(111)
        #ax1.set_title("RSS vs Time")
        ax1.set_xlabel('Time (min)')
        ax1.set_ylabel('RSS (GB)')
        x1 = [x / 60 for x in x1]
        y1 = [y / 1048576 for y in y1]
        y2 = [y / 1048576 for y in y2]
        ax1.plot(x1, y1, color='yellow', label='Base Pages')
        ax1.plot(x1, y2, color='orange', label='Large Pages')
        ax1.fill_between(x1, 0, y1, facecolor = 'yellow', interpolate=True)
        ax1.fill_between(x1, 0, y2, facecolor = 'orange', interpolate=True)
        ax1.set_xlim([0, x1[-1]])
        ax1.set_ylim([0, 1.2* max(max(y1),max(y2))])
        yellow_patch = mpatches.Patch(color='yellow', label='Base Pages')
        orange_patch = mpatches.Patch(color='orange', label='Large Pages')
        plt.legend([yellow_patch, orange_patch], ["Memory backed by Base Pages", "Memory backed by Large Pages"], loc='upper left')
        plt.show()

class forkplot:
    def __init__(self):
        #x = [129, 258, 515, 1031, 2061, 4121, 8241]

        y1 = [231, 400, 725, 1282, 2512]
        y2= [1263, 2427, 4881, 8589, 16973]
        x = np.arange(len(y1))
        fig1 = plt.figure()
        ax1 = fig1.add_subplot(111)
        #ax1.set_title("Time taken to Fork v/s RSS")
        ax1.set_ylabel('Time (ms)')
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

SIZE = 14
MEDIUM_SIZE = 14
BIGGER_SIZE = 16

plt.rc('font', size=SIZE)                # controls default text sizes
plt.rc('axes', titlesize=SIZE)           # fontsize of the axes title
plt.rc('axes', labelsize=MEDIUM_SIZE)    # fontsize of the x and y labels
plt.rc('xtick', labelsize=SIZE)          # fontsize of the tick labels
plt.rc('ytick', labelsize=SIZE)          # fontsize of the tick labels
plt.rc('legend', fontsize=SIZE)          # legend fontsize
plt.rc('figure', titlesize=BIGGER_SIZE)  # fontsize of the figure title

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
