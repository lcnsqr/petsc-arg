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
  output = split(chomp(read(cmd, String)))

  # Parse output fields
  main_stage = parse(Float64, output[1])
  min1 = parse(Float64, output[2])
  min5 = parse(Float64, output[3])
  min15 = parse(Float64, output[4])
  proc = output[5]

  # Return tuple with the five parsed values
  return main_stage, min1, min5, min15, proc
end

factorial_design = FullFactorial((
  ksp_type = ["cg", "gmres", "fcg", "tcqmr", "cgs", "bcgs", "tfqmr", "cr", "gcr"],
  pc_type = ["icc", "jacobi", "sor", "mg"]), @formula(y ~ ksp_type + pc_type))

# Get the results for each parameter line in factorial_design.matrix
exec_round = DataFrame(y.(eachrow(factorial_design.matrix)))

# Add names to the result columns
rename!(exec_round, Symbol.(["response", "min1", "min5", "min15", "proc"]))

# Concatenate parameter and result columns
results = hcat(factorial_design.matrix, exec_round)

# Save CSV
CSV.write("measurements_gpu.csv", results)

# Repeat the experiments
for i in 1:repetitions
  exec_round = DataFrame(y.(eachrow(factorial_design.matrix)))
  rename!(exec_round, Symbol.(["response", "min1", "min5", "min15", "proc"]))
  append!(results, hcat(factorial_design.matrix, exec_round))
  # Save CSV
  CSV.write("measurements_gpu.csv", results)
end
