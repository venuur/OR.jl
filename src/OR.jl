module OR

module Forecast
export mad, mse, mape, ma, ma!
mad(e) = sum(abs.(e)) / length(e)
mse(e) = sum(e.^2) / length(e)
mape(e, y) = sum(abs.(e ./ y)) / length(e) * 100
function ma!(yhat, y, n)
    for i in eachindex(y)[n+1:end]
        yhat[i-n] = sum(y[i-n:i-1]) / n
    end
    yhat
end
function ma(y, n)
    yhat = Array{Float64}(undef, length(y) - n)
    ma!(yhat, y, n)
end
end  # module Forecast

module Report
end # module Report

module Examples
import ..OR
include("examples\\OperationsAnalysis.jl")
end # module Examples

greet() = print("Hello World!")

end # module
