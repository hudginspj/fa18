import math
import os
import datetime
import time
from multiprocessing import Process, Pipe
from exact1 import *

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


