# -*- coding: utf-8 -*-
import random
import math
import itertools
from exact1 import *

print("hello")


def get_endpoints(points, n):
    #n = int(math.sqrt(len(points))) // 4
    num_per_edge = max(1,int(n//4))
    x_sorted = sorted(points, key=lambda p: p[0])
    y_sorted = sorted(points, key=lambda p: p[1])


    #return min_xs[:-1], max_xs[:-1], min_ys[:-1], max_ys[:-1]
    #return min_xs, max_xs, min_ys, max_ys
    endpoints = x_sorted[:num_per_edge] + x_sorted[-num_per_edge:] + y_sorted[:num_per_edge] + y_sorted[-num_per_edge:]
    #print(endpoints)
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


def one_split(cities):
    part0, part1 = x_partition(cities) 

    endpoints0 = get_endpoints(part0, math.sqrt(len(part0)))
    subsol0 = best_between_endpoints_annotated(part0, endpoints0)
    print(len(part0), len(endpoints0), len(subsol0))

    endpoints1 = get_endpoints(part1, math.sqrt(len(part1)))
    subsol1 = best_between_endpoints_annotated(part1, endpoints1)
    print(len(part1), len(endpoints1), len(subsol1))

    top_endpoints = get_endpoints(endpoints0+endpoints1, math.sqrt(len(cities)))
    print("top endpoints", len(top_endpoints), top_endpoints)

    return stitch(subsol0, subsol1, endpoints0, endpoints1, top_endpoints)


def stitch(subsol0, subsol1, endpoints0, endpoints1, top_endpoints):
    closest_pair_0 = None
    closest_pair_1 = None
    closest_pair_dist = float('inf')
    for e0 in endpoints0:
        for e1 in endpoints1:
            if length(e0, e1) < closest_pair_dist:     ##### TODO remember and don't recompute
                closest_pair_dist = length(e0, e1)
                closest_pair_0 = e0
                closest_pair_1 = e1

    print("closest pair", closest_pair_dist, closest_pair_0, closest_pair_1)


    #Start, end, distance, path
    res = []
    for s0 in subsol0:   #### TODO This makes most of the single unnecessary, unless we actually crunch all shortest paths
        #print(s0)
        for s1 in subsol1:
            if s0[0] in top_endpoints and s1[1] in top_endpoints and s0[0] != closest_pair_0 and s1[1] != closest_pair_1:
                if s1[0] == closest_pair_1:
                    #print("yup")
                    if s0[1] == closest_pair_0:
                        #print("esoji")
                        dist = s0[2] + closest_pair_dist + s1[2]
                        path = s0[3] + s1[3]
                        res.append((s0[0], s1[1], dist, path))
    #print(res)
    return res



def recursive_split(cities):
    if len(cities) < 12:
        endpoints = get_endpoints(cities, math.sqrt(len(cities)))
        sol = best_between_endpoints_annotated(cities, endpoints) 
        return sol, endpoints

    part0, part1 = x_partition(cities) 

    subsol0, endpoints0 = recursive_split(part0)
    subsol1, endpoints1 = recursive_split(part1)
    # endpoints0 = get_endpoints(part0, math.sqrt(len(part0)))
    # subsol0 = best_between_endpoints_annotated(part0, endpoints0)
    print(len(part0), len(endpoints0), len(subsol0))

    # endpoints1 = get_endpoints(part1, math.sqrt(len(part1)))
    # subsol1 = best_between_endpoints_annotated(part1, endpoints1)
    print(len(part1), len(endpoints1), len(subsol1))

    top_endpoints = get_endpoints(endpoints0+endpoints1, math.sqrt(len(cities)))
    print("top endpoints", len(top_endpoints), top_endpoints)

    sol = stitch(subsol0, subsol1, endpoints0, endpoints1, top_endpoints)
    return sol, top_endpoints

cities = gen_cities_annotated(16,500)
print("=" * 100)
res_os = best_closed_sol(one_split(cities))
print("os", total_distance(cities, res_os[1]), res_os)

rec_sols, endpoints = recursive_split(cities)
# print(rec_sols)
# print("???", endpoinres_os)
res_rec = best_closed_sol(rec_sols)
print("rec", total_distance(cities, res_rec[1]), res_rec)

res_held = solve_tsp_dynamic(cities)
print("held", total_distance(cities, res_held[1]), res_held)




#print(cities)

#min_paths = best_from_start(cities, 1, [2])
#min_paths += best_from_start(cities, 3, [2])
#min_paths += best_from_start(cities, 2, [1])
#min_paths = best_between_endpoints(cities, [1,2,3])
#for x in min_paths:
#    print(x)

#print(get_endpoints(cities, 16))
# for p in partition(cities):
#     print(p)

