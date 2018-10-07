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

def partition(cities):
    x_sorted = sorted(cities, key=lambda p: p[0])
    y_sorted = sorted(cities, key=lambda p: p[1])
    halfway = len(cities) // 2
    x_divider = x_sorted[halfway][0]
    y_divider = y_sorted[halfway][1]
    part1 = []
    part2 = []
    part3 = []
    part4 = []
    for p in cities:
        if p[0] < x_divider and p[1] < y_divider:
            part1.append(p)
        elif p[0] >= x_divider and p[1] < y_divider:
            part2.append(p)
        elif p[0] < x_divider and p[1] >= y_divider:
            part3.append(p)
        elif p[0] >= x_divider and p[1] >= y_divider:
            part4.append(p)
        else:
            raise Exception()
    return part1, part2, part3, part4


#test_annotate()

def one_split(cities):
    parts = partition(cities)

    subsolutions = []
    for part in parts:
        desired_num_endpoints = int(math.sqrt(len(part)))
        endpoints = get_endpoints(part, desired_num_endpoints)
        #print(len(part), desired_num_endpoints, len(endpoints))
     
        min_paths = best_between_endpoints_annotated(part, endpoints)
        #Start, end, distance
        subsolutions.append(min_paths)
        #print(len(part), desired_num_endpoints, len(endpoints), len(min_paths))
        #print([ep[2] for ep in endpoints])
        for x in min_paths:
            print(x)
        print("="*100)
    
    for 

cities = gen_cities_annotated(32,500)
one_split(cities)

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

