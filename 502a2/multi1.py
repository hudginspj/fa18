#!/usr/bin/python3
import math
import os
import datetime
import time
from multiprocessing import Process, Pipe
from heldkarp import *
from swap1 import *

def recursive_split_process(cities, depth, conn):
    #print("Starting ", os.getpid())
    res = recursive_split(cities, depth)
    #print("done: ", os.getpid())
    conn.send(res)
    conn.close()

def recursive_split(cities, all_cities, depth=0):
    
    if len(cities) < 11:
        path = exact_tsp(cities)
        # endpoints = get_endpoints(cities, math.sqrt(len(cities)))
        # sol = best_between_endpoints_annotated(cities, endpoints) # Held-karp
        # return sol, endpoints
        return path

    if depth % 2 == 0:
        part0, part1 = x_partition(cities)
    else:
        part0, part1 = y_partition(cities)

    # if depth <= 5:
        

    #     parent_conn_0, child_conn_0 = Pipe()
    #     p0 = Process(target=recursive_split_process, args=(part0, depth+1, child_conn_0))

    #     p0.start()

    #     subsol1, endpoints1 = recursive_split(part1, depth+1)

    #     subsol0, endpoints0 = parent_conn_0.recv()
    #     p0.join()
        
    # else:
    path0 = recursive_split(part0, all_cities, depth+1)
    path1 = recursive_split(part1, all_cities, depth+1)


    if depth < 5:
        pass
        print("  " * depth, len(cities), len(path0), len(path1))
    path = swap(path0, path1, all_cities)

    return path

def threaded_tsp(cities):
    return recursive_split(cities, cities, depth=0)

def threaded_trial(n):
    cities = gen_cities(n,500)
    #cities = read_cities()

    start_time = datetime.datetime.now()
    path = threaded_tsp(cities)
    runtime = (datetime.datetime.now() - start_time).total_seconds()
    
    distance = total_distance(cities, path)
    return n, runtime, distance



if __name__ == "__main__":
    print(threaded_trial(200))
    

