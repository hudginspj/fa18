#!/usr/bin/python3
import math
import os
import datetime
import time
from swap1 import *
from mpi4py import MPI

#print("hello")

comm = MPI.COMM_WORLD
rank = comm.Get_rank()


def recursive_split_MPI():
    cities, all_cities, depth = comm.recv(source=MPI.ANY_SOURCE, tag=MPI.ANY_TAG)
    res = recursive_split(cities, all_cities, depth)
    dest_rank = rank - math.pow(2, depth-1)
    comm.send(res, dest=dest_rank, tag=11)


def recursive_split(cities, all_cities, depth=0):
    if len(cities) <= BLOCK_SIZE:
        path = exact_tsp(cities)
        return path

    if depth % 2 == 0:
        part0, part1 = x_partition(cities)
    else:
        part0, part1 = y_partition(cities)

    if depth <= SPLIT_DEPTH:
        sub_rank = rank + int(math.pow(2, depth))
        comm.send((part0, all_cities, depth+1), dest=sub_rank, tag=11)

        path1 = recursive_split(part1, all_cities, depth+1)

        path0 = comm.recv(source=sub_rank, tag=MPI.ANY_TAG)

        
    else:
        path0 = recursive_split(part0, all_cities, depth+1)
        path1 = recursive_split(part1, all_cities, depth+1)


    if depth < 4:
        pass
        print("  " * depth, len(cities), len(part0), len(path0), len(part1), len(path1))
    path = swap(path0, path1, all_cities)

    return path

def mpi_tsp(cities):
    path = recursive_split(cities, cities, depth=0)
    return path

def mpi_trial(n):
    cities = gen_cities(n,500)

    start_time = datetime.datetime.now()
    path = mpi_tsp(cities)
    runtime = (datetime.datetime.now() - start_time).total_seconds()
    
    distance = total_distance(cities, path)
    return n, runtime, distance

BLOCK_SIZE = 10
SPLIT_DEPTH = 4
if rank != 0:
    recursive_split_MPI()
else:
    n, runtime, distance = mpi_trial(1000)
    print((SPLIT_DEPTH, n, runtime, distance))
    



