module OperationsAnalysis
using OR.Forecast
using Printf

export example_2_1, example_2_2, example_2_3

"""
    example_2_1()

Example 2.1: Illustration of mean absolute deviation (MAD), mean squared error, and mean
absolute percentage error (MAPE). Usage is for measuring forecast error. Example compares
two forecasts `p1` and `p2` for their respective series `o1` and `o2`.

"""
function example_2_1()
    println("Operations Analysis Example 2.1")
    println("-------------------------------")

    p1 = [92, 87, 95, 90, 88, 93]
    o1 = [88, 88, 97, 83, 91, 93]
    e1 = p1 .- o1

    p2 = [96, 89, 92, 93, 90, 85]
    o2 = [91, 89, 90, 90, 86, 89]
    e2 = p2 .- o2

    mad1 = mad(e1)
    mad2 = mad(e2)
    best_mad = mad1 < mad2 ? 1 : 2
    println("Plant $best_mad has the best MAD (1: $mad1 vs. 2: $mad2)")

    mse1 = sum(e1.^2) / length(e1)
    mse2 = sum(e2.^2) / length(e2)
    best_mse = mse1 < mse2 ? 1 : 2
    println("Plant $best_mse has the best MSE (1: $mse1 vs. 2: $mse2)")

    mape1 = mape(e1, o1)
    mape2 = mape(e2, o2)
    best_mape = mape1 < mape2 ? 1 : 2
    println("Plant $best_mape has the best MAPE (1: $mape1 vs. 2: $mape2)")
    println()
end

"""
    example_2_2()

Example 2.2: Illustration of moving average over 3 and 6 periods, denoted MA(3) and MA(6).
The example presents the forecast and errors as a table.

"""
function example_2_2()
    println("Operations Analysis Example 2.2")
    println("-------------------------------")

    y = [200, 250, 175, 186, 225, 285, 305, 190]

    ma3 = ma(y, 3)
    ma3e = ma3 .- y[4:end]

    ma6 = ma(y, 6)
    ma6e = ma6 .- y[7:end]

    @printf "        Engine\n"
    @printf "Quarter Failure   MA(3)   Error   MA(6)   Error\n"
    for i = 1:3
        @printf "%-7d %7d\n" i y[i]
    end
    for i = 4:6
        @printf "%-7d %7d %7.1f %7.1f\n" i y[i] ma3[i-3] ma3e[i-3]
    end
    for i = 7:8
        @printf("%-7d %7d %7.1f %7.1f %7.1f %7.1f\n",
                i, y[i], ma3[i-3], ma3e[i-3], ma6[i-6], ma6e[i-6])
    end
    println()
end

function example_2_3()
    println("Operations Analysis Example 2.3")
    println("-------------------------------")

    y = [200, 250, 175, 186, 225, 285, 305, 190]
    esf0 = 200
    α = 0.1

    esf = es(y, esf0, α)

    println("Quarter Failures Forecast")
    @printf "%7d %8d %8.1f*\n" 1 y[1] esf0
    for i in eachindex(y)[2:end]
        @printf "%7d %8d %8.1f\n" i y[i] esf[i-1]
    end
    println()
    println("* Assumed initial forecast")
    println()

    println("Comparison with MA(3)")
    ma3 = ma(y, 3)
    ma3e = ma3 .- y[4:end]
    esfe = esf .- y[2:end]

    println("Quarter Failures   MA(3) |Error| ES(0.1) |Error|")
    for i in eachindex(y)[4:end]
        @printf("%7d %8d %7.1f %7.1f %7.1f %7.1f\n",
                i, y[i], ma3[i-3], abs(ma3e[i-3]), esf[i-1], abs(esfe[i-1]))
    end
    println()

    println("Forecast error")
    ma3_mad = mad(ma3e)
    esf_mad = mad(esfe[3:end])
    ma3_mse = mse(ma3e)
    esf_mse = mse(esfe[3:end])

    println("Model       MAD     MSE")
    @printf "MA(3)   %7.1f %7.1f\n" ma3_mad ma3_mse
    @printf "ES(0.1) %7.1f %7.1f\n" esf_mad esf_mse
end

function example_2_4()
    println("Operations Analysis Example 2.4")
    println("-------------------------------")

    y = [200, 250, 175, 186, 225, 285, 305, 190]
    n = 5

    a, b = lr(y[1:n])

    # Included to make the exercise complete, but not need for calculating a and b, Because
    # that is handled by the lr function.
    sxx = n^2*(n + 1)*(2*n + 1) / 6 - n^2*(n + 1)^2 / 4
    sxy = n*sum((1:n).*y[1:n]) - n*(n+1) / 2 * sum(y[1:n])

    println("Checking our work...")
    println("S_xy = $sxy")
    println("S_xx = $sxx")
    println("b    = $b")
    println("a    = $a")
    println()

    @printf "yhat(t) = %.1f + (%.1f)t" a b
    println()
end

end  # module OperationsAnalysis
