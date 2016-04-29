__author__ = 'Sejal Chauhan'
__author_email__ = 'sejalc@cs.wisc.edu'
__version__ = '1.0'

import re
import sys
import numpy as np
import matplotlib.pyplot as plt

class latency:

    def __init__(self, data1):

        y1 = []
        for s in data1.split('\n'):
            for token in s.split():
                try:
                    token = int(token)
                except ValueError:
                    token = float(token)
            y1.append(token)
        x1 = np.arange(len(y1))
        fig1 = plt.figure()
        ax1 = fig1.add_subplot(111)
        ax1.set_title("Latency v/s Time in ms")
        ax1.set_xlabel("Time")
        ax1.set_ylabel("Latency")
        ax1.plot(x1, y1, c='r')
        plt.show()

class latencyp:

    def __init__(self, data1):

        y1=[]
        for s in data1.split('\n'):
            for token in s.split():
                try:
                    x = re.findall("\d+", s)
                    if len(x)>0:
                        t = int(x[0])
                    #if t<80 or t>90:
                        y1.append(t)
                except ValueError:
                    pass
        fig1 = plt.figure()
        x1 = np.arange(len(y1))
        ax1 = fig1.add_subplot(111)
        ax1.set_title("Latency time series")
        ax1.set_xlabel('Time in ms')
        ax1.set_ylabel('Latency in ms')
        ax1.plot(x1,y1)
        frame1 = plt.gca()
        frame1.axes.get_xaxis().set_visible(False)
        ax1.set_ylim([-5,600])
        #fig1.subplots_adjust(bottom=1.2)
        #pl.setp(labels, rotation=90)
        plt.show()

if __name__ == '__main__':
    with open(sys.argv[1], 'rb') as f1:
        data1 = f1.read()

        if sys.argv[2] == '1':
            latency(data1)
        if sys.argv[2] == '2':
            latencyp(data1)
