from __future__ import division
__author__ = 'Sejal Chauhan'
__author_email__ = 'sejalc@cs.wisc.edu'
__version__ = '1.0'

import re
import sys
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec

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

def forkplot():

    y1 = [231, 400, 725, 1282, 2512]
    y2= [1263, 2427, 4881, 8589, 16973]
    x = np.arange(len(y1))

    gs1 = gridspec.GridSpec(2, 1)
    fig1 = plt.figure()
    ax1 = fig1.add_subplot(gs1[0])
    ax1.set_ylabel('Time (ms)')
    ax1.set_xlabel('RSS')
    y1 = [y/1000 for y in y1]
    y2 = [y/1000 for y in y2]
    rects1 = ax1.plot(x, y1, color=(27/255,158/255,119/255), marker='o', markersize=8)
    rects2 = ax1.plot(x, y2, color=(217/255,95/255,2/255), marker='^', markersize=8)
    xlabel = ['128MB', '256MB', '512MB', '1GB', '2GB']
    plt.xticks(x, xlabel)
    ax1.set_xticklabels(xlabel, rotation='horizontal')
    ax1.legend((rects1[0], rects2[0]), ('THP Disabled', 'THP Enabled'), shadow=False, loc='upper left')
    plt.tight_layout()
    plt.show()

if __name__ == '__main__':
     forkplot()
