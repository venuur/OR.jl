module OR

module Forecast
export mad, mse, mape
mad(e) = sum(abs.(e)) / length(e)
mse(e) = sum(e.^2) / length(e)
mape(e, y) = sum(abs.(e ./ y)) / length(e) * 100
end  # module Forecast

module Examples
import ..OR
include("examples\\OperationsAnalysis.jl")
end # module Examples

greet() = print("Hello World!")

end # module
