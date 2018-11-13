#!/usr/bin/python3
import math
import os
import datetime
import time
from heldkarp import *
from swap1 import *

def ccw(A,B,C):
    return (C[1]-A[1]) * (B[0]-A[0]) > (B[1]-A[1]) * (C[0]-A[0])

# Return true if line segments AB and CD intersect
def intersect(A,B,C,D):
    return ccw(A,C,D) != ccw(B,C,D) and ccw(A,B,C) != ccw(A,B,D)


def is_inv(four_idx, all_cities):
    i0, i1, j0, j1 = four_idx
    a0, a1, b0, b1 = [all_cities[i] for i in four_idx]
    return ccw(a0,b0,b1) != ccw(a1,b0,b1) and ccw(a0,a1,b0) != ccw(a0,a1,b1)
    # if a0[0] > a1[0]:
    #     a1, a0 = a0, a1
    # if b0[0] > b1[0]:
    #     b1, b0 = b0, b1
    # inv = True
    # inv = inv and (a0[1] - b0[1]) * (a1[1] - b1[1]) < 0 # 
    # # inv = inv and min(a0[0], a1[0]) < max(b0[0], 1[0])
    # # inv = inv and min(a0[0], a1[0]) < max(b0[0], 1[0])

    # return inv


def show_inv(path, all_cities):
    pass


def inv_test():
    cities = [[0,0], [0,1], [1,0], [1,1]]
    print(is_inv([0,3,1,2], cities))


if __name__ == "__main__":
    inv_test()
    

