import math
import os
import datetime
import time
from multiprocessing import Process, Pipe
from heldkarp import *
import matplotlib.pyplot as plt
import numpy as np

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



def swap(path0, path1, all_cities):
    def index_length(i, j):
        return length(all_cities[i], all_cities[j])
    def swap_cost():
        return index_length(l0, r0) + index_length(l1, r1) - index_length(l0, l1) - index_length(r0, r1)
    best_swap_cost = float("inf")
    best_swap = (None, None, None, None)
    
    for i0 in range(len(path0)):   #TODO handle last i
        i1 = (i0+1)%len(path0)
        l0 = path0[i0]
        l1 = path0[i1]
        for j0 in range(len(path1)):
            j1 = (j0+1)%len(path1)
            r0 = path1[j0]
            r1 = path1[j1]
            if swap_cost() < best_swap_cost:
                # plot_path(path0, all_cities, 'g')
                # plot_path(path1, all_cities, 'b')
                # plot_path([l0, l1, r0, r1], all_cities, 'ro')
                # print(swap_cost())
                # plt.show()
                best_swap_cost = swap_cost()
                best_swap = (i0, i1, j0, j1)
            r0 = path1[j1]
            r1 = path1[j0]
            if swap_cost() < best_swap_cost:
                # plot_path(path0, all_cities, 'g')
                # plot_path(path1, all_cities, 'b')
                # plot_path([l0, l1, r0, r1], all_cities, 'ro')
                # print(swap_cost())
                # plt.show()
                
                best_swap_cost = swap_cost()
                best_swap = (i0, i1, j0, j1)
    (i0, i1, j0, j1) = best_swap
    
    
    if i1 == 0:
        path = path0[1:i0+1]
    else:
        path = path0[:i0+1]
    
    # if j0 == 0 and j1 == 1:
    #     path += path1[0]
    #     path += reversed(path1[1:])
    if j0 == 0 and j1 == 6:
        path += path1
    elif j0 == 6 and j1 == 0:
        path += reversed(path1)    
    elif j0 > j1:
        path += path1[j0:]
        path += path1[:j1+1]
    else:
        path += list(reversed(path1[:j0+1]))
        path += list(reversed(path1[j1:]))

    if i1 == 0:
        path.append(path0[0])
    else:
        path += path0[i1:]
    # print(best_swap)
    # print(path)
    # plot_path(path0, all_cities, 'g')
    # plot_path(path1, all_cities, 'b')
    # swap_points = (path0[i0], path0[i1], path1[j0], path1[j1])
    # plot_path(swap_points, all_cities, 'ro')
    # plot_path(path, all_cities, 'r:')
    return path
    

def one_swap(cities, all_cities):
    part0, part1 = x_partition(cities)
    path0 = exact_tsp(part0)
    path1 = exact_tsp(part1)
    # print(path0)
    # print(path1)
    path = swap(path0, path1, all_cities)
    return path


def swap_test(n):
    cities = gen_cities(n,500)
    print("len cities", len(cities))
    #cities = read_cities()

    start_time = datetime.datetime.now()
    path = one_swap(cities, cities)
    runtime = (datetime.datetime.now() - start_time).total_seconds()
    
    distance = total_distance(cities, path)
    print(distance)

    #plot_path(path, cities)

    path_opt = exact_tsp(cities)
    distance_opt = total_distance(cities, path_opt)
    print(distance_opt)

    #plot_path(path, cities)


    #return len(cities), runtime, distance
    return distance/distance_opt


def plot_path(path, all_cities, color, swap_points=None):
    x = [all_cities[i][0] for i in path]
    y = [all_cities[i][1] for i in path]
    plt.plot(x, y, color)
    plt.grid(True)
    #plt.show()
   


if __name__ == "__main__":
    ratios = []
    for i in range(100):
        ratios.append(swap_test(14))
    print(ratios)
    print(np.mean(ratios))
    plt.show()
    
