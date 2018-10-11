import math
import os
import datetime
import time
from multiprocessing import Process, Pipe
from exact1 import *
from mpi4py import MPI

print("hello")

comm = MPI.COMM_WORLD
rank = comm.Get_rank()



def get_endpoints(points, n):
    #n = int(math.sqrt(len(points))) // 4
    num_per_edge = max(1,int(n//4))
    x_sorted = sorted(points, key=lambda p: p[0])
    y_sorted = sorted(points, key=lambda p: p[1])


    #return min_xs[:-1], max_xs[:-1], min_ys[:-1], max_ys[:-1]
    #return min_xs, max_xs, min_ys, max_ys
    endpoints = x_sorted[:num_per_edge] + x_sorted[-num_per_edge:] + y_sorted[:num_per_edge] + y_sorted[-num_per_edge:]
    return list(set(endpoints))

def x_partition(cities):
    x_sorted = sorted(cities, key=lambda p: p[0])
    halfway = len(cities) // 2
    x_divider = x_sorted[halfway][0]
    part1 = []
    part2 = []
    for p in cities:
        if p[0] < x_divider:
            part1.append(p)
        elif p[0] >= x_divider:
            part2.append(p)
        else:
            raise Exception()
    return part1, part2

def y_partition(cities):
    y_sorted = sorted(cities, key=lambda p: p[1])
    halfway = len(cities) // 2
    y_divider = y_sorted[halfway][1]
    part1 = []
    part2 = []
    for p in cities:
        if p[1] < y_divider:
            part1.append(p)
        elif p[1] >= y_divider:
            part2.append(p)
        else:
            raise Exception()
    return part1, part2

comps = []
non_comps = []

def stitch(subsol0, subsol1, endpoints0, endpoints1, top_endpoints):
    closest_pair_0 = None
    closest_pair_1 = None
    closest_pair_dist = float('inf')
    for e0 in endpoints0:
        #if e0 not in top_endpoints:  #TODO is this a good assumption?
            for e1 in endpoints1:
                #if e1 not in top_endpoints:
                    if length(e0, e1) < closest_pair_dist:     ##### TODO remember and don't recompute
                        closest_pair_dist = length(e0, e1)
                        closest_pair_0 = e0
                        closest_pair_1 = e1

    #print("closest pair", closest_pair_dist, closest_pair_0, closest_pair_1)


    #Start, end, distance, path
    res = []
    for s0 in subsol0:   #### TODO This makes most of the single unnecessary, unless we actually crunch all shortest paths
        for s1 in subsol1:
            if s0[0] in top_endpoints and s1[1] in top_endpoints and s0[0] != closest_pair_0 and s1[1] != closest_pair_1:
                if s1[0] == closest_pair_1:
                    if s0[1] == closest_pair_0:
                        dist = s0[2] + closest_pair_dist + s1[2]
                        path = s0[3] + s1[3]
                        res.append((s0[0], s1[1], dist, path))
    if len(res) == 0:   #TODO how much worse does this make the solution?
        #print("compensating")
        comps.append(len(top_endpoints))
        top_endpoints = set()
        for s0 in subsol0[:3]:
            for s1 in subsol1[:3]:
                #if s0[0] in top_endpoints and s1[1] in top_endpoints:
                        dist = s0[2] + length(s0[1], s1[0]) + s1[2]
                        path = s0[3] + s1[3]
                        top_endpoints.add(s0[0])
                        top_endpoints.add(s1[1])
                        res.append((s0[0], s1[1], dist, path))
                        res.append((s1[1], s0[0], dist, list(reversed(path))))
        top_endpoints = list(top_endpoints)
    else:
        non_comps.append(len(top_endpoints))

    if len(res) == 0:
        print("failed")
        print(subsol0)
        print(subsol1)
        raise Exception("failed to compensate")
    return res, top_endpoints


def recursive_split_MPI():
    cities, depth = comm.recv(source=MPI.ANY_SOURCE, tag=MPI.ANY_TAG)
    #print("Starting ", os.getpid())
    res = recursive_split(cities, depth)
    dest_rank = rank - math.pow(2, depth-1)
    #print("done: ", os.getpid())
    comm.send(res, dest=dest_rank, tag=11)
    #conn.send(res)
    #conn.close()

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
        data = {'a': 7, 'b': 3.14}
        sub_rank = rank + int(math.pow(2, depth)
        comm.send((part0, depth+1), dest=sub_rank, tag=11)
        # parent_conn_0, child_conn_0 = Pipe()
        # p0 = Process(target=recursive_split_process, args=(part0, depth+1, child_conn_0))
        # p0.start()
        subsol1, endpoints1 = recursive_split(part1, depth+1)

        subsol0, endpoints0 = comm.recv(source=sub_rank, tag=MPI.ANY_TAG)

        
    else:
        subsol0, endpoints0 = recursive_split(part0, depth+1)
        subsol1, endpoints1 = recursive_split(part1, depth+1)



    top_endpoints = get_endpoints(endpoints0+endpoints1, math.sqrt(len(cities)))

    if depth < 5:
        print("  " * depth, len(cities), len(subsol0), len(subsol1), len(top_endpoints))

    return stitch(subsol0, subsol1, endpoints0, endpoints1, top_endpoints)

if rank != 0:
    recursive_split_MPI()
else:
#if __name__ == "__main__":
    start_time = datetime.datetime.now()


    cities = gen_cities_annotated(1000,500)
    print("=" * 100)

    rec_sols, endpoints = recursive_split(cities)
    res_rec = best_closed_sol(rec_sols)
    #print("rec", res_rec)
    print("length:", total_distance(cities, res_rec[1]))

    stop_time = datetime.datetime.now()
    print(stop_time - start_time)


