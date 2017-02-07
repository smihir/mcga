from __future__ import division
__author__ = 'Vikas Goel'
__author_email__ = 'vikasgoel@cs.wisc.edu'
__version__ = '1.0'
import re
import sys
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.font_manager import FontProperties

SIZE = 14
MEDIUM_SIZE = 14
BIGGER_SIZE = 16

plt.rc('font', size=SIZE)  # controls default text sizes
plt.rc('axes', titlesize=SIZE)  # fontsize of the axes title
plt.rc('axes', labelsize=BIGGER_SIZE)  # fontsize of the x and y labels
plt.rc('xtick', labelsize=SIZE)  # fontsize of the tick labels
plt.rc('ytick', labelsize=SIZE)  # fontsize of the tick labels
plt.rc('legend', fontsize=SIZE)  # legend fontsize


# plt.rc('figure', titlesize=BIGGER_SIZE)  # fontsize of the figure title

class rssvstime:
    def __init__(self, data1, data2, data3, data4):

        y1 = []
        y2 = []
        y3 = []

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
                    if (int(x[1]) == 0):
                        splitLines.append(count)

                    elif (pLargePg / int(x[1])) > 2:
                        splitLines.append(count)
                    pLargePg = int(x[1])
                    count = count + 1

                    y1.append(t1)  # Total RSS
                    y2.append(t2)  # Total Small pages
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

                    y3.append(t1 * 1024 * 2)  # Total Large Page Promoted
            except ValueError:
                pass

        for i in range(0, len(y3) - 1):
            y3[i] = y3[i] + y2[i]

        y11 = []
        y21 = []
        y31 = []

        splitLines1 = []
        pLargePg1 = 0
        count1 = 1

        for s1 in data3.split('\n'):
            try:
                x1 = re.findall("\d+", s1)

                if len(x1) > 0:
                    t11 = int(x1[0])
                    t21 = t11 - int(x1[1])

                    # Find split instances
                    if (int(x1[1]) == 0):
                        splitLines1.append(count1)

                    elif (pLargePg1 / int(x1[1])) > 2:
                        splitLines1.append(count1)
                    pLargePg1 = int(x1[1])
                    count1 = count1 + 1

                    y11.append(t11)  # Total RSS
                    y21.append(t21)  # Total Small pages
            except ValueError:
                pass

        for x1 in splitLines1:
            print x1

        count1 = 1
        pLargePg1 = 0
        for s1 in data4.split('\n'):
            try:
                x1 = re.findall("\d+", s1)

                if len(x1) > 0:
                    t11 = int(x1[0])

                    if count1 in splitLines1:
                        pLargePg1 = t11

                    t11 = t11 - pLargePg1
                    count1 = count1 + 1

                    y31.append(t11 * 1024 * 2)  # Total Large Page Promoted
            except ValueError:
                pass

        for i in range(0, len(y31) - 1):
            y31[i] = y31[i] + y21[i]

        fig1 = plt.figure()
        x1 = np.arange(len(y1))
        ax1 = fig1.add_subplot(221)
        ax1.set_xlabel('Time (min)')
        ax1.set_ylabel('RSS (GB)')
        x1 = [x / 60 for x in x1]
        y1 = [y / 1048576 for y in y1]
        y2 = [y / 1048576 for y in y2]
        y3 = [y / 1048576 for y in y3]

        color1 = (227/255,74/255,51/255)
        color2 = (253/255,187/255,132/255)
        color3 = (254/255,232/255,200/255)
        ax1.plot(x1, y1, color=color1, label='Base Pages')
        ax1.plot(x1, y2, color=color3, label='Large Pages')
        ax1.plot(x1, y3, color=color2, label='Allocation Pages')

        ax1.fill_between(x1, 0, y1, facecolor=color1, interpolate=True)
        ax1.fill_between(x1, 0, y3, facecolor=color2, interpolate=True)
        ax1.fill_between(x1, 0, y2, facecolor=color3, interpolate=True)

        ax1.set_xlim([0, x1[-1]])
        ax1.set_ylim([0, 1.2 * max(max(y1), max(y2))])

        x11 = np.arange(len(y11))
        ax11 = fig1.add_subplot(222)
        ax11.set_xlabel('Time (min)')
        ax11.set_ylabel('RSS (GB)')
        x11 = [x / 60 for x in x11]
        y11 = [y / 1048576 for y in y11]
        y21 = [y / 1048576 for y in y21]
        y31 = [y / 1048576 for y in y31]

        ax11.plot(x11, y11, color=color1, label='Memory backed by Base Pages')
        ax11.plot(x11, y21, color=color3, label='Memory backed by Promoted Large Pages')
        ax11.plot(x11, y31, color=color2, label='Memory backed by Allocated Large Pages')

        ax11.fill_between(x11, 0, y11, facecolor=color1, interpolate=True)
        ax11.fill_between(x11, 0, y31, facecolor=color2, interpolate=True)
        ax11.fill_between(x11, 0, y21, facecolor=color3, interpolate=True)

        ax11.set_xlim([0, x11[-1]])
        ax11.set_ylim([0, 1.2 * max(max(y11), max(y21))])

        yellow_patch = mpatches.Patch(color=color1)
        orange_patch = mpatches.Patch(color=color3)
        blue_patch = mpatches.Patch(color=color2)

        fontP = FontProperties()
        fontP.set_size('large')

        #plt.legend([yellow_patch, blue_patch, orange_patch],
                   #["Memory backed by Allocated Large Pages", "Memory backed by Promoted Large Pages", "Memory backed by Base Pages"], fancybox=True, bbox_to_anchor=(-0.60, 1.25),prop=fontP)
        #plt.legend([yellow_patch, blue_patch, orange_patch],
                    #["Memory backed by Allocated Large Pages", "Promoted Large Pages", "Base Pages"], bbox_to_anchor=(0., 1.02, 1., .102), loc=3, ncol=2, mode="expand", borderaxespad=0.)
        plt.legend([yellow_patch, blue_patch, orange_patch], ["Memory backed by Allocated Large Pages", "Promoted Large Pages", "Base Pages"], bbox_to_anchor=(0., 1.02, 1., .102), mode="expand", borderaxespad=0.)
        plt.savefig("rssPlot.png")
        plt.show()


if __name__ == '__main__':
    if len(sys.argv) >= 3:
        print "python rssPlot3.py <path to the directory of result>"

    arg = sys.argv[1]
    if arg.endswith("/"):
        smap = arg + "smap.out"
        promote = arg + "thppromote.out"
    else:
        smap = arg + "/smap.out"
        promote = arg + "/thppromote.out"

    arg = sys.argv[2]
    if arg.endswith("/"):
        smap1 = arg + "smap.out"
        promote1 = arg + "thppromote.out"
    else:
        smap1 = arg + "/smap.out"
        promote1 = arg + "/thppromote.out"

    with open(smap, 'rb') as f1:
        data1 = f1.read()
        with open(promote, 'rb') as f2:
            data2 = f2.read()
            with open(smap1, 'rb') as f3:
                data3 = f3.read()
                with open(promote1, 'rb') as f4:
                    data4 = f4.read()
                    rssvstime(data1, data2, data3, data4)
