"""
References
----------

[1] Steven Nahmias, "Production & Operations Analysis." Sixth Edition, 2009.

"""
module OR

"""
Moving average and exponential smoothing forecasts assume a stationary demand process.
Hence, their one step ahead and multi-step ahead forecasts are identical. The basic model is
the following

    D(t) = μ + ε(t),    ∀ t.

Naturally, this is a strong assumption in industries such as retail that have heavy
seasonality.  Although, the assumption may be locally accurate, say within the weekdays, or
of the weekly demand withing several months. Finally, using large α or small N can make the
forecasts more responsive to small trends.

"""
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
# p. 71 [1]
ma_avg_age(n) = (n+1) / 2

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
# p. 71 [1]
es_avg_age(α) = inv(α)

end  # module Forecast

module Report
end # module Report

module Examples
import ..OR
include("examples\\OperationsAnalysis.jl")
end # module Examples

greet() = print("Hello World!")

end # module
