#Local install of mpi4py
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user
pip3 install --user mpi4py

#Running single-threaded:
mpiexec -n 4 python3 tsp6mpi.py

