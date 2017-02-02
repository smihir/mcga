from __future__ import division
__author__ = 'Sejal Chauhan'
__author_email__ = 'sejalc@cs.wisc.edu'
__version__ = '1.0'

import re
import sys
import numpy as np
import matplotlib.pyplot as plt

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
if __name__ == '__main__':
     forkplot()
