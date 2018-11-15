
import math

BLOCK_SIZE = 10
SPLIT_DEPTH = 4
x_dim = 2**int(math.ceil(SPLIT_DEPTH+1/2.0))
y_dim = 2**int(math.floor(SPLIT_DEPTH+1/2.0))


