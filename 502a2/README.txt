

### Local install of mpi4py ###
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user
pip3 install --user mpi4py

## Running single-threaded solution ####
./gen_cities.t 16 | ./heldkarp.py

## Running multiprocess solution ####
./gen_cities.t 100000 | ./tsp_multiprocess.py

### Running mpi solution: ###
./gen_cities.t 1000 | mpiexec -n 32 ./tsp_mpi.py
### Note limitations for MPI reading large files from stdin

