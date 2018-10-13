import math
import os
import datetime
import time
from multiprocessing import Process, Pipe
from exact1 import *
from stitch import *
from tsp5threaded import *


#import matplotlib.pyplot as plt

def comparison():
    sizes = list(range(8,17))
    #sizes = [20]
    threaded_trials = []
    exact_trials = []
    for s in sizes:
        t = threaded_trial(s)
        threaded_trials.append(t)
        print("threaded", t)
        if s < 25:
            t2 = exact_trial(s)
            exact_trials.append(t2)
            print("exact", t2)
            print("ratio", t[2]/t2[2])

def exact_times():
    sizes = list(range(12,20))
    trials = []
    for s in sizes:
        t = exact_trial(s)
        trials.append(t)
        print("exact", t)
    print(sizes)
    print(trials)
    
    # plt.plot(sizes, [t[1] for t in trials])

    # plt.xlabel('Num cities')
    # plt.ylabel('Runtime (s)')
    # plt.title('Single-threaded runtimes')
    # plt.grid(True)
    # plt.savefig("exact_runtimes.png")
    # plt.show()


def threaded_times(start, end):
    sizes = [int(math.pow(2, x)) for x in range(start, end)]
    trials = []
    for s in sizes:
        t = threaded_trial(s)
        trials.append(t)
        print("threaded", t)
    print(sizes)
    print(trials)
    # plt.loglog(sizes, [t[1] for t in trials])
    # plt.xlabel('Num cities')
    # plt.ylabel('Runtime (s)')
    # plt.title('Multiprocess runtimes, 32 processes')
    # plt.grid(True)
    # plt.savefig("multi_runtimes.png")
    # plt.show()

# def threaded_lengths(start, end):
#     sizes = [int(math.pow(2, x)) for x in range(start, end)]
#     trials = []
#     for s in sizes:
#         t = threaded_trial(s)
#         trials.append(t)
#         print("threaded", t)
    
#     # plt.loglog(sizes, [t[2] for t in trials])
#     # plt.xlabel('Num cities')
#     # plt.ylabel('Path Length')
#     # plt.title('Multiprocess path lengths')
#     # plt.grid(True)
#     # plt.savefig("multi_paths.png")
#     # plt.show()

# def gen_plot():
#     n = [1,2,4,8,16,32]
#     times = [5,5,5,5,5]
#     plt.loglog(n,times)
#     plt.xlabel('Num processes')
#     plt.ylabel('Runtime (s)')
#     plt.title('MPI runtimes for 100000 cities')
#     plt.grid(True)
#     plt.savefig("mpi.png")
#     plt.show()


if __name__ == "__main__":
    #comparison()
    exact_times()
    #threaded_times(5,12)
    #threaded_lengths(5,12)

