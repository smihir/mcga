__author__ = 'Sejal Chauhan'
__author_email__ = 'sejalc@cs.wisc.edu'
__version__ = '1.0'

import re
import sys
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

class rssvstime:

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

if __name__ == '__main__':
    with open(sys.argv[1], 'rb') as f1:
        data1 = f1.read()
        rssvstime(data1)
