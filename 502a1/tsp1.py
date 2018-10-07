# -*- coding: utf-8 -*-
import random
import math
import itertools

print("hello")



def gen_cities(n, max_xy):
    min_xy = max_xy / 200.0
    def coord():
        return min_xy + random.uniform(min_xy, max_xy)
    return [(coord(), coord()) for i in range(n)]

def gen_cities_annotated(n, max_xy):
    cities = gen_cities(n,max_xy)
    points = []
    for i, p in enumerate(cities):
        points.append((p[0], p[1], i+10))
    return points

def length(a, b):
    return math.sqrt((a[0]-b[0])**2 + (a[1]-b[1])**2 )

def solve_tsp_dynamic(points):  ###### TODO delete
    #calc all lengths
    all_distances = [[length(x,y) for y in points] for x in points]
    #initial value - just distance from 0 to every other point + keep the track of edges
    #{(S, endpoint):(distance, path)}
    A = {(frozenset([0, idx+1]), idx+1): (dist, [0,idx+1]) for idx,dist in enumerate(all_distances[0][1:])}
    cnt = len(points)
    for m in range(2, cnt):
        B = {}
        for S in [frozenset(C) | {0} for C in itertools.combinations(range(1, cnt), m)]:
            for j in S - {0}:
                B[(S, j)] = min( [(A[(S-{j},k)][0] + all_distances[k][j], A[(S-{j},k)][1] + [j]) for k in S if k != 0 and k!=j])  #this will use 0th index of tuple for ordering, the same as if key=itemgetter(0) used
        A = B
    res = min([(A[d][0] + all_distances[0][d[1]], A[d][1]) for d in iter(A)])
    #print([(A[d][0] + all_distances[0][d[1]], A[d][1]) for d in iter(A)])
    #print("A", A)
    #for d in iter(A):
    #    print(A[d])
    #    print(d)
    return [(d[1], A[d]) for d in iter(A) if d[1] in endpoints]
    #return res[1]
    
def best_from_start(points, start, endpoints):   ########### TODO copied code, rewrite
    #calc all lengths
    points = points.copy()
    points[0], points[start] = points[start], points[0]
    
    all_distances = [[length(x,y) for y in points] for x in points]
    #print(points)
    
    #print(points)
    
    #initial value - just distance from 0 to every other point + keep the track of edges
    #{(S, endpoint):(distance, path)}
    A = {(frozenset([0, idx+1]), idx+1): (dist, [0,idx+1]) for idx,dist in enumerate(all_distances[0][1:])}
    cnt = len(points)
    for m in range(2, cnt):
        B = {}
        for S in [frozenset(C) | {0} for C in itertools.combinations(range(1, cnt), m)]:
            for j in S - {0}:
                B[(S, j)] = min( [(A[(S-{j},k)][0] + all_distances[k][j], A[(S-{j},k)][1] + [j]) for k in S if k != 0 and k!=j])  #this will use 0th index of tuple for ordering, the same as if key=itemgetter(0) used
        A = B
    #res = min([(A[d][0] + all_distances[0][d[1]], A[d][1]) for d in iter(A)])
    def remap(p):
        if p == 0:
            return start
        elif p == start:
            return 0
        else:
            return p
            
    res = [(d[1], A[d][0], [remap(p) for p in A[d][1]]) for d in iter(A) if d[1] in endpoints]
    
        
    return res
    #return res[1]
    
def best_between_endpoints(points, endpoints):
    res = []
    for i in range(len(endpoints)):
        start = endpoints[i]
        for solution in best_from_start(points, start, endpoints[:i] + endpoints[i+1:]):
            res.append((start, solution[0], solution[1], solution[2]))
            #res.append((solution[0], start, solution[1], solution[2]))
    return res
    

def get_endpoints(points, n):
    #n = int(math.sqrt(len(points))) // 4
    num_per_edge = int(n//4)
    x_sorted = sorted(points, key=lambda p: p[0])
    y_sorted = sorted(points, key=lambda p: p[1])


    #return min_xs[:-1], max_xs[:-1], min_ys[:-1], max_ys[:-1]
    #return min_xs, max_xs, min_ys, max_ys
    return x_sorted[:num_per_edge] + x_sorted[-num_per_edge:] + y_sorted[:num_per_edge] + y_sorted[-num_per_edge:]

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


def best_from_start_annotated(points, start_point, endpoints):   ########### TODO copied code, rewrite
    points = points.copy()

    start = points.index(start_point)
    points[0], points[start] = points[start], points[0]
    
    all_distances = [[length(x,y) for y in points] for x in points]
    
    #initial value - just distance from 0 to every other point + keep the track of edges
    #{(S, endpoint):(distance, path)}
    A = {(frozenset([0, idx+1]), idx+1): (dist, [0,idx+1]) for idx,dist in enumerate(all_distances[0][1:])}
    cnt = len(points)
    for m in range(2, cnt):
        B = {}
        for S in [frozenset(C) | {0} for C in itertools.combinations(range(1, cnt), m)]:
            for j in S - {0}:
                B[(S, j)] = min( [(A[(S-{j},k)][0] + all_distances[k][j], A[(S-{j},k)][1] + [j]) for k in S if k != 0 and k!=j])  #this will use 0th index of tuple for ordering, the same as if key=itemgetter(0) used
        A = B
    
    res = []
    endpoint_indexes = [points.index(ep) for ep in endpoints]
    for set_endpoint in iter(A):
        if set_endpoint[1] in endpoint_indexes:
            endpoint = points[set_endpoint[1]]
            distance = A[set_endpoint][0]
            calc_path = A[set_endpoint][1]
            path = [points[index][2] for index in calc_path]
            #print(calc_path, path)
            res.append((endpoint, distance, path))

    return res
    
def best_between_endpoints_annotated(points, endpoints):
    res = []
    for i in range(len(endpoints)):
        start = endpoints[i]
        for solution in best_from_start_annotated(points, start, endpoints[:i] + endpoints[i+1:]):
            res.append((start, solution[0], solution[1], solution[2]))
            #res.append((solution[0], start, solution[1], solution[2]))
    return res

def test_annotate():
    cities = gen_cities(6,500)
    points = []
    for i, p in enumerate(cities):
        points.append((p[0], p[1], i+10))
    
    min_paths = best_between_endpoints(cities, [1,2,3])
    for x in min_paths:
       print(x)
    print()
    min_paths = best_between_endpoints_annotated(points, [points[1],points[2],points[3]])
    for x in min_paths:
        print(x)
    
#test_annotate()

def one_split(cities):
    parts = partition(cities)

    for part in parts:
        n = int(math.sqrt(len(part))) // 4
        endpoints = get_endpoints(part, n)
        print(part)
        print(endpoints)
        #min_paths = best_between_endpoints_annotated(part, endpoints)
        #for x in min_paths:
        #    print(x)
        print("="*100)

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

