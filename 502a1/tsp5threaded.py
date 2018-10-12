import math
import os
import datetime
import time
from multiprocessing import Process, Pipe
from exact1 import *
from stitch import *

def recursive_split_process(cities, depth, conn):
    #print("Starting ", os.getpid())
    res = recursive_split(cities, depth)
    #print("done: ", os.getpid())
    conn.send(res)
    conn.close()

def recursive_split(cities, depth=0):
    
    if len(cities) < 11:
        endpoints = get_endpoints(cities, math.sqrt(len(cities)))
        sol = best_between_endpoints_annotated(cities, endpoints) # Held-karp
        return sol, endpoints

    if depth % 2 == 0:
        part0, part1 = x_partition(cities)
    else:
        part0, part1 = y_partition(cities)

    if depth <= 1:
        # parent_conn_0, child_conn_0 = Pipe()
        # p0 = Process(target=recursive_split_process, args=(part0, depth+1, child_conn_0))
        # parent_conn_1, child_conn_1 = Pipe()
        # p1 = Process(target=recursive_split_process, args=(part1, depth+1, child_conn_1))

        # p0.start()
        # #time.sleep(3)
        # p1.start()

        # subsol0, endpoints0 = parent_conn_0.recv()
        # subsol1, endpoints1 = parent_conn_1.recv()
        # p0.join()
        # p1.join()

        parent_conn_0, child_conn_0 = Pipe()
        p0 = Process(target=recursive_split_process, args=(part0, depth+1, child_conn_0))

        p0.start()

        subsol1, endpoints1 = recursive_split(part1, depth+1)

        subsol0, endpoints0 = parent_conn_0.recv()
        p0.join()
        
    else:
        subsol0, endpoints0 = recursive_split(part0, depth+1)
        subsol1, endpoints1 = recursive_split(part1, depth+1)



    top_endpoints = get_endpoints(endpoints0+endpoints1, math.sqrt(len(cities)))

    if depth < 5:
        pass
        #print("  " * depth, len(cities), len(subsol0), len(subsol1), len(top_endpoints))

    return stitch(subsol0, subsol1, endpoints0, endpoints1, top_endpoints)

def threaded_tsp(cities):
    rec_sols, endpoints = recursive_split(cities)
    res_rec = best_closed_sol(rec_sols)
    return res_rec[1]

def threaded_trial(n):
    cities = gen_cities_annotated(n,500)

    start_time = datetime.datetime.now()
    path = threaded_tsp(cities)
    runtime = (datetime.datetime.now() - start_time).total_seconds()
    
    distance = total_distance(cities, path)
    return n, runtime, distance



if __name__ == "__main__":
    print(threaded_trial(1000))
    

