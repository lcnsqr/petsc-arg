include ${PETSC_DIR}/${PETSC_ARCH}/lib/petsc/conf/petscvariables

# MPI parameters

NP = 1
RES = 1000

# Default PETSc parameters

MAT_TYPE = aij
MAT_SOLVER_TYPE = cusparse
KSP_TYPE = gmres
PC_TYPE = icc


all: solver solver_dmda

solver: solver.c
	${CC} ${CC_FLAGS} ${PETSC_CC_INCLUDES} $^ ${CC_LINKER_SLFLAG}${PETSC_DIR}/${PETSC_ARCH}/lib ${PETSC_WITH_EXTERNAL_LIB} -o $@

solver_dmda: solver_dmda.c
	${CC} ${CC_FLAGS} ${PETSC_CC_INCLUDES} $^ ${CC_LINKER_SLFLAG}${PETSC_DIR}/${PETSC_ARCH}/lib ${PETSC_WITH_EXTERNAL_LIB} -o $@

.PHONY: core cuda thread

cuda_dmda:
	${PETSC_DIR}/${PETSC_ARCH}/bin/mpirun -np ${NP} ./solver_dmda -da_grid_x ${RES} -da_grid_y ${RES} -mat_type ${MAT_TYPE} -vec_type cuda -mat_solver_type ${MAT_SOLVER_TYPE} -ksp_type ${KSP_TYPE} -pc_type ${PC_TYPE} -log_view

cuda:
	${PETSC_DIR}/${PETSC_ARCH}/bin/mpirun -np ${NP} ./solver -m ${RES} -n ${RES} -mat_type ${MAT_TYPE} -vec_type cuda -mat_solver_type ${MAT_SOLVER_TYPE} -ksp_type ${KSP_TYPE} -pc_type ${PC_TYPE} -log_view

thread_dmda:
	${PETSC_DIR}/${PETSC_ARCH}/bin/mpirun -np ${NP} --use-hwthread-cpus --map-by hwthread --display-map ./solver_dmda -da_grid_x ${RES} -da_grid_y ${RES} -mat_type ${MAT_TYPE} -ksp_type ${KSP_TYPE} -pc_type ${PC_TYPE} -log_view

thread:
	${PETSC_DIR}/${PETSC_ARCH}/bin/mpirun -np ${NP} --use-hwthread-cpus --map-by hwthread --display-map ./solver -m ${RES} -n ${RES} -mat_type ${MAT_TYPE} -ksp_type ${KSP_TYPE} -pc_type ${PC_TYPE} -log_view

core_dmda:
	${PETSC_DIR}/${PETSC_ARCH}/bin/mpirun -np ${NP} --map-by core --display-map ./solver_dmda -da_grid_x ${RES} -da_grid_y ${RES} -mat_type ${MAT_TYPE} -ksp_type ${KSP_TYPE} -pc_type ${PC_TYPE} -log_view

core:
	${PETSC_DIR}/${PETSC_ARCH}/bin/mpirun -np ${NP} --map-by core --display-map ./solver -m ${RES} -n ${RES} -mat_type ${MAT_TYPE} -ksp_type ${KSP_TYPE} -pc_type ${PC_TYPE} -log_view
