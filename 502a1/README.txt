

### Local install of mpi4py ###
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user
pip3 install --user mpi4py

### Running mpi solution: ###
mpiexec -n 32 python3 tsp_mpi.py

