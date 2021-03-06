"""
References
----------

[1] Steven Nahmias, "Production & Operations Analysis." Sixth Edition, 2009.

"""
module OR

"""
Moving average and exponential smoothing forecasts assume a stationary demand process.
Hence, their one step ahead and multi-step ahead forecasts are identical. The basic model is
the following:

    D(t) = μ + ε(t),    ∀ t.

Naturally, this is a strong assumption in industries such as retail that have heavy
seasonality.  Although, the assumption may be locally accurate, say within the weekdays, or
of the weekly demand withing several months. Finally, using large α or small N can make the
forecasts more responsive to small trends.

Linear regression on the demand time series assumes the following functional form represents
the underlying demand process:

    D(t) = a + b t + ε(t),    ∀ t.

Because the regression is in a single, simple independent variable, calculating the
coefficients is linear in the size of the data. The solution is analytical involving only
simple arithmetic.

"""
module Forecast
export mad, mse, mape, ma, ma!, es, es!, lr, es2, es2!
mad(e) = sum(abs.(e)) / length(e)
mse(e) = sum(e.^2) / length(e)
mape(e, y) = sum(abs.(e ./ y)) / length(e) * 100

function ma!(yhat, y, n)
    for i in eachindex(y)[n+1:end]
        yhat[i-n] = sum(y[i-n:i-1]) / n
    end
    yhat
end
"""
    ma(y, n)
    ma!(yhat, y, n)

Generate an `n` period moving average for time series `y`. The in place version `ma!`
expects a vector of length `length(y) - n`.

"""
function ma(y, n)
    yhat = Array{Float64}(undef, length(y) - n)
    ma!(yhat, y, n)
end
# p. 71 [1]
ma_avg_age(n) = (n+1) / 2

es_op(y, yhat, α, α1) = α*y + α1*yhat
"""
    es_op(y, yhat, α)
    es_op(y, yhat, α, α1)

Update exponential smoothing forecast given most recent obervation `y` and forecast `yhat`
with smoohting coefficient `α`. The four argument version expects `α1 = one(α) - α`, which
is used to avoid recalculating that term in repeated calls.

"""
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
"""
    es(y, yhat0, α)
    es!(yhat, y, yhat0, α)

Generate an exponential smoothing with initial forecast `yhat0` and smoothing coefficient
`α` for a time series `y`. The in place version `es!` expects a vector of length
`length(y) - 1`.

"""
function es(y, yhat0, α)
    yhat = Array{Float64}(undef, length(y) - 1)
    es!(yhat, y, yhat0, α)
end
# p. 71 [1]
es_avg_age(α) = inv(α)

"""
    lr(y)

Returns intercept and slope of a linear trend line fitted to the time series `y`.

"""
function lr(y::Vector{T}) where T
    n = length(y)
    c = n*(n+1) / 2
    sxx = c*n*(2*n + 1) / 3 - c^2

    # Formula
    #     S_xy = n sum((1:y).*y) - c sum(y)
    sxy::T = 0
    for i in eachindex(y)
        sxy += (n*i - c) * y[i]
    end

    dbar = sum(y) / n
    b = sxy / sxx
    a = dbar - b*(n+1) / 2

    a, b
end

function es2!(s, g, y, s0, g0, α, β)
    α1 = one(α) - α
    β1 = one(β) - β
    s[1] = es_op(y[1], s0+g0, α, α1)
    g[1] = es_op(s[1]-s0, g0, β, β1)
    for i in eachindex(s)[2:end]
        im1 = i - 1
        s[i] = es_op(y[i], s[im1]+g[im1], α, α1)
        g[i] = es_op(s[i]-s[im1], g[im1], β, β1)
    end
    s, g
end

"""
    es2(y, s0, g0, α, β)
    es2!(s, g, y, s0, g0, α, β)

Double exponential smoothing via Holt's method (p. 77 [1]). Performs exponential smoothing
for the intercept `s` and then estimates the slope via exponential smoothing using the
differences `s[t]-s[t-1]`. Initial intercept and slope forecasts are `s0` and `g0`.
Smoothing coefficients for intercept and slope `α` and `β`. The in place version `es2!`
expects vectors `s` and `g` to have length `length(y) - 1`.

"""
function es2(y, s0, g0, α, β)
    s = Array{Float64}(undef, length(y) - 1)
    g = Array{Float64}(undef, length(y) - 1)
    es2!(s, g, y, s0, g0, α, β)
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
