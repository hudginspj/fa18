
import math

BLOCK_SIZE = 10
SPLIT_DEPTH = -1
x_dim = 2**int(math.ceil((SPLIT_DEPTH+1)/2.0))
y_dim = 2**int(math.floor((SPLIT_DEPTH+1)/2.0))

print(x_dim, y_dim)
