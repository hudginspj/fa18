#!/usr/bin/python3
import math
import os
import datetime
import time
from multiprocessing import Process, Pipe
from tsp_multiprocess import *


import matplotlib.pyplot as plt

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

def gen_plot():
    exact = [(12, 0.308518, 1410.573606372794), (13, 0.66318, 1632.2654389463469), (14, 1.291908, 1644.9079540054465), (15, 2.972672, 1594.614057433886), (16, 7.255922, 1900.5308333439898), (17, 12.035563, 1694.5869959347815), (18, 27.95391, 2049.2214614380773), (19, 71.089776, 2127.4454125701654)]
    threaded = [(32, 0.109987, 3374.3300111364874), (64, 0.080559, 4443.821707431034), (128, 0.068734, 6234.644767204211), (256, 0.119872, 9520.810996826156), (512, 0.19564, 13876.396383205703), (1024, 0.272207, 19687.670917319054), (2048, 0.407043, 27915.628068446073), (4096, 0.701226, 39433.292256469955), (8192, 1.143495, 56978.70383243054), (16384, 1.956642, 80953.62882265907), (32768, 3.783329, 113287.29979875693), (65536, 6.362242, 161886.04610121594), (131072, 12.003298, 226896.47151622412), (262144, 22.458317, 324815.35598222975), (524288, 44.716109, 453348.49928575405), (1048576, 84.545519, 650551.2911656635)]
#     mpi = [(-1, 100000, 39.083396, 205715.17017352598), (0, 100000, 19.710998, 205855.56733377307), (1, 100000, 11.894998, 205895.05950446794), (2, 100000, 7.048315, 205650.53719821534), (3, 100000, 5.362279, 204877.55455947947), (4, 100000, 3.666327, 205460.60029320346)]
    mpi = [(1, 100000, 39.083396, 205715.17017352598), (2, 100000, 19.710998, 205855.56733377307), (4, 100000, 11.894998, 205895.05950446794), (8, 100000, 7.048315, 205650.53719821534), (16, 100000, 5.362279, 204877.55455947947), (32, 100000, 3.666327, 205460.60029320346)]
    # plt.plot([t[0] for t in mpi],[t[2] for t in mpi])
    # plt.xlabel('Num processes')
    # plt.ylabel('Runtime (s)')
    # plt.title('MPI runtimes for 100000 cities')
    # plt.grid(True)
    # plt.savefig("mpi.png")
    # plt.show()
    # plt.plot([t[0] for t in threaded],[t[2] for t in threaded])
    # plt.xlabel('Num Cities')
    # plt.ylabel('Distance')
    # plt.title('Recurive bisection path length')
    # plt.grid(True)
    # plt.savefig("distance.png")
    # plt.show()
    p = [(500,10179), (5000,32178), (50000,106000), (500000,321000)]
    
    #p = [(,), (,), (,), (,), (,), (,), ]
    p = [(1,96/96), (2,96/57), (4,96/31), (8,96/26), (16,96/16.6), (32,96/14.5)]
    #p = [(500,1), (5000,12), (50000,96), (500000,1639)]
    p = [(50,0.2/0.1), (500,1/0.4), (5000,12/3.6), (50000,96/16.6), (500000,1639/199)]

    plt.loglog([t[0] for t in p],[t[1] for t in p])
    #plt.plot([t[0] for t in p],[t[1] for t in p])
    plt.xlabel('Num Cities')
    #plt.xlabel('Num processes')
    #plt.ylabel('Path length')
    #plt.ylabel('Runtime (s)')
    plt.ylabel('Speedup (s)')
    #plt.title('Path length')
    plt.grid(True)
    plt.savefig("multi.png")
    print(p)
    plt.show()
    
    # plt.plot([t[0] for t in exact],[t[1] for t in exact])
    # plt.xlabel('Num Cities')
    # plt.ylabel('Runtime (s)')
    # plt.title('Runtime, exact solution on one process')
    # plt.grid(True)
    # plt.savefig("exact.png")
    # plt.show()


if __name__ == "__main__":
    #comparison()
    #exact_times()
    #threaded_times(5,12)
    #threaded_lengths(5,12)
    gen_plot()

