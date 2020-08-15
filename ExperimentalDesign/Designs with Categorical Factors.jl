using ExperimentalDesign, StatsModels, GLM, DataFrames, Distributions, Random, StatsPlots, CSV

#cmd_prefix = ["singularity", "exec", "--nv", "../container/petsc-gpu.sif", "make", "-s", "-C", "../src"]
cmd_prefix = ["make", "-s", "-C", "../src"]
dev = "cuda"
np = 1
res = 1000
repetitions = 15

# Response function
function y(x)
  parameters = []
  for i in 1:length(x)
      push!(parameters, rstrip(string(uppercase(string(keys(x)[i])), "=", x[i], " ")))
  end
  
  println(parameters)
  cmd = `$cmd_prefix $[dev, "NP=$np", "RES=$res"] $parameters`

  # Run external experiment command
  main_stage = parse(Float64, chomp(read(cmd, String)))
  return main_stage
end

factorial_design = FullFactorial((
  ksp_type = ["cg", "gmres", "fcg", "tcqmr", "cgs", "bcgs", "tfqmr", "cr", "gcr"],
  pc_type = ["jacobi", "sor", "mg"]), @formula(y ~ ksp_type + pc_type))

factorial_design.matrix[!, :response] = y.(eachrow(factorial_design.matrix))

results = copy(factorial_design.matrix)

for i in 1:repetitions
  factorial_design.matrix[!, :response] = y.(eachrow(factorial_design.matrix))
  append!(results, copy(factorial_design.matrix))
  # Save CSV
  CSV.write("repeated_measurements_full.csv", results)
end
