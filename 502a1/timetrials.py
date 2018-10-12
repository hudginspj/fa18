import math
import os
import datetime
import time
from multiprocessing import Process, Pipe
from exact1 import *
from stitch import *
from tsp5threaded import *


def time_trial():
    sizes = [8,9,10,11,12,13,14,15,16,30,100,300,1000,3000,10000,30000,100000]
    for s in sizes:
        print(threaded_trial(s))


if __name__ == "__main__":
    time_trial()

