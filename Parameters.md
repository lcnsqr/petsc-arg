# Search Space Parameters

Parameters related to memory management and where the program should be executed.

<table>
<thead>
<tr>
<th>Parameter</th><th>Usage</th><th>Description</th><th>Sub-parameter</th><th>Description</th>
</tr>
</thead>
<tbody>

<!-- IMPL -->
<tr>
  <td rowspan="3">Computing device</td>
  <td rowspan="2">-cpu</td>
  <td rowspan="2">CPU only execution</td>
  <td>-np &lt;n&gt;</td>
  <td>Number of processing units. Default: 1.</td>
</tr>
<tr>
  <td>-cpu_type &lt;core,thread&gt;</td>
  <td>What to count as a processing unit. Default: core</td>
</tr>
<tr>
  <td>-gpu</td>
  <td>GPU execution</td>
  <td>-gpu_type &lt;cuda,opencl&gt;</td>
  <td>GPU Execution with CUDA or OpenCL. Default: cuda.</td>
</tr>

<!-- DMDA -->
<tr>
  <td>DMDA<br><em>Distributed array</em></td>
  <td>-dmda &lt;on,off&gt;</td>
  <td colspan="3">Employment of distributed arrays when communication of nonlocal data is needed. Default: off.</td>
</tr>

</tbody>
</table>

PETSc provides a  simple mechanism to customize its data  structures and methods
at  runtime,  called  *options  database*. The following table lists the options
relevant for the purpose of tuning the execution of linear PDE solvers.

<table>
<thead>
<tr>
<th>Parameter</th><th>Usage</th><th>Description</th><th>Sub-parameter</th><th>Description</th>
</tr>
</thead>
<tbody>

<!-- KSP -->
<tr>
  <td rowspan="12">KSP<br><em>PETSc linear solver Krylov method</em></td>
  <td>-ksp_type cg</td>
  <td>Preconditioned Conjugate Gradient (PCG) iterative method</td>
  <td>-ksp_cg_single_reduction</td>
  <td>Performs both inner products needed in the algorithm with a single MPIU_Allreduce() call</td>
</tr>
<tr>
  <td rowspan="2">-ksp_type gmres</td>
  <td rowspan="2">Generalized Minimal Residual method</td>
  <td>-ksp_gmres_restart <restart></td>
  <td>Sets number of iterations. The default value is 30.</td>
</tr>
<tr>
  <td>-ksp_gmres_preallocate</td>
  <td>Causes GMRES to preallocate all its needed work vectors at initial setup rather than the default, which is to allocate them in chunks when needed.</td>
</tr>
<tr>
  <td rowspan="3">-ksp_type fcg</td>
  <td rowspan="3">Flexible Conjugate Gradient method (FCG)</td>
  <td>-ksp_fcg_mmax &lt;N&gt;</td>
  <td>Maximum number of search directions. Default: 30</td>
</tr>
<tr>
  <td>-ksp_fcg_nprealloc &lt;N&gt;</td>
  <td>Number of directions to preallocate. Default: 10</td>
</tr>
<tr>
  <td>-ksp_fcg_truncation_type &lt;standard,notay&gt;</td>
  <td>Truncation approach for directions. Standard uses all (up to mmax) stored directions notay uses the last max(1,mod(i,mmax)) stored directions at iteration i=0,1..</td>
</tr>
<tr>
  <td>-ksp_type tcqmr</td>
  <td colspan="3">A variant of QMR (quasi minimal residual)</td>
</tr>
<tr>
  <td>-ksp_type cgs</td>
  <td colspan="3">CGS (Conjugate Gradient Squared) method</td>
</tr>
<tr>
  <td>-ksp_type bcgs</td>
  <td colspan="3">BiCGStab (Stabilized version of BiConjugate Gradient) method</td>
</tr>
<tr>
  <td>-ksp_type tfqmr</td>
  <td colspan="3">A transpose free QMR (quasi minimal residual)</td>
</tr>
<tr>
  <td>-ksp_type cr</td>
  <td colspan="3">The (preconditioned) conjugate residuals method</td>
</tr>
<tr>
  <td>-ksp_type gcr</td>
  <td>Preconditioned Generalized Conjugate Residual method</td>
  <td>-ksp_gcr_restart &lt;restart&gt;</td>
  <td>The number of stored vectors to orthogonalize against. The default value is 30.</td>
</tr>

<!-- PC -->
<tr>
  <td rowspan="9">PC<br><em>PETSc preconditioner method</em></td>
  <td rowspan="2">-pc_type jacobi</td>
  <td rowspan="2">Jacobi (i.e. diagonal scaling preconditioning)</td>
  <td>-pc_jacobi_type &lt;diagonal,rowmax,rowsum&gt;</td>
  <td>Approach for forming the preconditioner. Causes the Jacobi preconditioner to use either the diagonal, the maximum entry in each row, of the sum of rows entries for the diagonal preconditioner. Default: Diagonal.</td>
</tr>
<tr>
  <td>-pc_jacobi_abs</td>
  <td>Use the absolute value of the diagonal entry. Default: not set.</td>
</tr>
<tr>
  <td rowspan="2">-pc_type sor</td>
  <td rowspan="2">SOR (successive over relaxation, Gauss-Seidel) preconditioning</td>
  <td>-pc_sor_local_symmetric</td>
  <td>Activates local symmetric version (default version). Perform separate independent smoothings on each processor.</td>
</tr>
<tr>
  <td>-pc_sor_symmetric</td>
  <td>Activates symmetric version.</td>
<tr>
  <td rowspan="2">-pc_type bjacobi</td>
  <td rowspan="2">Block Jacobi preconditioning, each block is (approximately) solved with its own KSP object</td>
  <td>-pc_bjacobi_blocks &lt;n&gt;</td>
  <td>Use n total blocks. Default: -1</td>
</tr>
<tr>
  <td>-pc_bjacobi_local_blocks &lt;n&gt;</td>
  <td>Use n local blocks. Default: -1</td>
</tr>
<tr>
  <td rowspan="3">-pc_type mg</td>
  <td rowspan="3">Multigrid preconditioning. This preconditioner requires you provide additional information about the coarser grid matrices and restriction/interpolation operators</td>
  <td>-pc_mg_cycle_type &lt;v,w&gt;</td>
  <td>V cycle or for W-cycle</td>
</tr>
<tr>
  <td>-pc_mg_type &lt;multiplicative,additive,full,kaskade&gt;</td>
  <td>Multigrid type</td>
</tr>
<tr>
  <td>-pc_mg_galerkin &lt;both,pmat,mat,none,external&gt;</td>
  <td>Use Galerkin process to compute coarser operators</td>
</tr>

</tbody>
</table>
