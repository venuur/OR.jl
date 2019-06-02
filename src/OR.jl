module OR

module Forecast
export mad, mse, mape, ma, ma!, es, es!
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

es_op(y, yhat, α, α1) = α*y + α1*yhat
es_op(y, yhat, α) = es_op(y, yhat, α, one(α) - α)
function es!(yhat, y, yhat0, α)
    α1 = one(α) - α
    idx = eachindex(yhat)
    i = idx[1]
    yhat[i] = es_op(y[i], yhat0, α, α1)
    for i in idx[2:end]
        yhat[i] = es_op(y[i], yhat[i-1], α, α1)
    end
    yhat
end
function es(y, yhat0, α)
    yhat = Array{Float64}(undef, length(y) - 1)
    es!(yhat, y, yhat0, α)
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
