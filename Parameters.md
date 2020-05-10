# PETSc Search Space Parameters

PETSc provides a  simple mechanism to customize its data  structures and methods
at  runtime,  called  *options  database*. The following table lists the options
relevant for the purpose of tuning the execution of a PDE solver.

<table>
<thead>
<tr>
<th>Parameter</th><th>Values</th><th>Description</th>
</tr>
</thead>
<tbody>

<!-- IMPL -->
<tr>
  <td rowspan="5"><strong>IMPL</strong><br><em>Implementation</em></td>
  <td>core</td>
  <td>CPU sequential execution</td>
</tr>
<tr>
  <td>coreN</td>
  <td>CPU based parallelism, N processes</td>
</tr>
<tr>
  <td>threadN</td>
  <td>Thread based parallelism, N processes</td>
</tr>
<tr>
  <td>cuda</td>
  <td>GPU Execution with CUDA/Thrust</td>
</tr>
<tr>
  <td>opencl</td>
  <td>GPU Execution with OpenCL</td>
</tr>


<!-- DMDA -->
<tr>
  <td><strong>DMDA</strong><br><em>Distributed array</em></td>
  <td>Boolean</td>
  <td>Employment of distributed arrays when communication of nonlocal data is needed</td>
</tr>

<!-- KSP -->
<tr>
  <td rowspan="9"><strong>KSP</strong><br><em>PETSc linear solver Krylov method</em></td>
  <td>cg</td>
  <td>Preconditioned Conjugate Gradient (PCG) iterative method</td>
</tr>
<tr>
  <td>gmres</td>
  <td>Generalized Minimal Residual method</td>
</tr>
<tr>
  <td>fcg</td>
  <td>Flexible Conjugate Gradient method (FCG)</td>
</tr>
<tr>
  <td>tcqmr</td>
  <td>A variant of QMR (quasi minimal residual)</td>
</tr>
<tr>
  <td>cgs</td>
  <td>CGS (Conjugate Gradient Squared) method</td>
</tr>
<tr>
  <td>bcgs</td>
  <td>BiCGStab (Stabilized version of BiConjugate Gradient) method</td>
</tr>
<tr>
  <td>tfqmr</td>
  <td>A transpose free QMR (quasi minimal residual)</td>
</tr>
<tr>
  <td>cr</td>
  <td>The (preconditioned) conjugate residuals method</td>
</tr>
<tr>
  <td>gcr</td>
  <td>Preconditioned Generalized Conjugate Residual method</td>
</tr>

<!-- PC -->
<tr>
  <td rowspan="4"><strong>PC</strong><br><em>PETSc preconditioner method</em></td>
  <td>jacobi</td>
  <td>Jacobi (i.e. diagonal scaling preconditioning)</td>
</tr>
<tr>
  <td>sor</td>
  <td>SOR (successive over relaxation, Gauss-Seidel) preconditioning</td>
</tr>
<tr>
  <td>bjacobi</td>
  <td>Block Jacobi preconditioning, each block is (approximately) solved with its own KSP object</td>
</tr>
<tr>
  <td>mg</td>
  <td>Multigrid preconditioning. This preconditioner requires you provide additional information about the coarser grid matrices and restriction/interpolation operators</td>
</tr>

</tbody>
</table>