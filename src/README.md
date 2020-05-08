# Test Programs

Both test programs solve a 2D Laplacian PDE using PETSc's KSP linear solvers:

|Program            |Description                                                                |
|-------------------|---------------------------------------------------------------------------|
|solver.c           |Solves a linear system in parallel with KSP.                               |
|solver_dmda.c      |Solves a linear system in parallel with KSP and distributed arrays (DMDAs).|

Distributed arrays (DMDAs) are intended for use with logically regular rectangular grids when communication of nonlocal data is needed before certain local computations can occur.

# Requirements

## CUDA Toolkit

In order to perform the GPU tests, the CUDA toolkit must be available.

- [CUDA Toolkit general installation instructions](https://developer.nvidia.com/cuda-downloads).
- [Instructions on how to create CUDA enabled containers](https://github.com/lcnsqr/petsc-arg/wiki/CUDA-enabled-Linux-Containers).

## PETSc

When working with GPU solvers, it is recommended to use the latest master branch from [PETSc git repository](https://gitlab.com/petsc/petsc.git). The test programs should work with a basic PETSc setup (without any external solver libraries), but a custom installation of *OpenMPI* will avoid any incompatibilities with the build provided by the distribution.

The many build options are detailed in the [PETSc installation instructions](https://www.mcs.anl.gov/petsc/documentation/installation.html). To the impatient, the following configuration settings enough to run the test programs:

    ./configure \
    --with-debugging=no \
    --with-fortran-bindings=0 --with-fc=0 \
    --download-openmpi \
    --with-cuda \
    COPTFLAGS='-O3 -march=native -mtune=native' \
    CXXOPTFLAGS='-O3 -march=native -mtune=native' \
    CUDAOPTFLAGS='-O3 -arch compute_50 -code sm_50'

The `-arch` and `-code` options in `CUDAOPTFLAGS` are optional, but they set important flags to the `nvcc` CUDA compiler. GPU compilation is performed via an intermediate representation, PTX, which can be considered as assembly for a virtual GPU architecture.  Option `-arch` specify the name of the class of NVIDIA virtual GPU architecture for which the CUDA input files must be compiled and option `-code` specify the name of the NVIDIA GPU to assemble and optimize PTX for. Detailed information about CUDA compiler flags are available in the [CUDA Compiler Reference Guide](https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html).

# Compiling

The following shell environment variables must be available, so the compiler can incorporate PETSc objects to the programs:

- `PETSC_DIR`: Path to the PETSc root directory.
- `PETSC_ARCH`: The architecture PETSc was built for, probably *arch-linux2-c-opt*.

Running `make all` will build both test programs.

# Running

Tests are implemented using *make* targets. For example:

    # Launch 8 processes, one per CPU, to find the solution for a 1000x1000 surface mesh.
    `make core NP=8 RES=1000`
    
    # Launch 8 threads, to find the solution for a 1000x1000 surface mesh.
    `make thread NP=8 RES=1000`
    
    # Launch the GPU based solver, using the *aijcusparse* matrix type.
    `make cuda RES=1000 MAT_TYPE=aijcusparse`

# Parameters

The (possible incomplete) list of parameters can be found in Parameters.md