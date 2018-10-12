import math
import os
import datetime
import time
from multiprocessing import Process, Pipe
from exact1 import *
from stitch import *
from tsp5threaded import *


def time_trial():
    for i in range(2,14):
        print(threaded_trial(int(math.pow(2,i))))


if __name__ == "__main__":
    time_trial()

