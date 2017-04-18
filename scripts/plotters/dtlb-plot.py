from __future__ import division
import sys
import numpy as np
import matplotlib.pyplot as plt

# USAGE python dtlb-plot.py <redis-tlb-miss>

SIZE = 14
MEDIUM_SIZE = 14
BIGGER_SIZE = 16

plt.rc('font', size=SIZE)  # controls default text sizes
plt.rc('axes', titlesize=SIZE)  # fontsize of the axes title
plt.rc('axes', labelsize=BIGGER_SIZE)  # fontsize of the x and y labels
plt.rc('xtick', labelsize=SIZE)  # fontsize of the tick labels
plt.rc('ytick', labelsize=SIZE)  # fontsize of the tick labels
plt.rc('legend', fontsize=SIZE)  # legend fontsize

def pltSeparate(data1):
    dTLBloadmisses = list()
    dTLBloads = list()
    dTLBstoremisses = list()
    dTLBstores = list()

    with open(data1) as f:
        for line in f:
            arr = line.split(',')
            if (arr[3]=='dTLB-load-misses'):
                try:
                    arr[1] = float(arr[1])
                except:
                    arr[1] = 0
                dTLBloadmisses.append(arr[1])

            elif (arr[3]=='dTLB-loads'):
                try:
                    arr[1] = float(arr[1])
                except:
                    arr[1] = 0
                dTLBloads.append(arr[1])

            elif (arr[3]=='dTLB-store-misses'):
                try:
                    arr[1] = float(arr[1])
                except:
                    arr[1] = 0
                dTLBstoremisses.append(arr[1])

            elif(arr[3]=='dTLB-stores'):
                try:
                    arr[1] = float(arr[1])
                except:
                    arr[1] = 0
                dTLBstores.append(arr[1])

    #print dTLBloadmisses
    fig1 = plt.figure()
    x1 = np.arange(len(dTLBloadmisses))
    x2 = np.arange(len(dTLBloads))
    x3 = np.arange(len(dTLBstoremisses))
    x4 = np.arange(len(dTLBstores))

    x = min(len(x1),len(x2),len(x3),len(x4))
    x = np.arange(x)
    ax1 = fig1.add_subplot(111)
    ax1.set_xlabel('Time (sec)')
    ax1.set_ylabel('Number')


    dTLBloadratio = [(dTLBstoremisses[i])/(dTLBstores[i]) for i in range(len(x))]
    #dtlblm, = ax1.plot(x, dTLBloadmisses, label='dTLBloadmisses')
    #dtlbl, = ax1.plot(x, dTLBloads, label='dTLBloads')
    #dtlbsm = ax1.plot(x, dTLBstoremisses, label='dTLBstoremisses')
    #dtlbs = ax1.plot(x, dTLBstores, label='dTLBstores')

    dtlblr, = ax1.plot(x, dTLBloadratio, label='dTLBloadratio')
    ax1.legend([dtlblr])
    plt.show()


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print "Provide arguments"

    arg = sys.argv[1]
    pltSeparate(arg)
