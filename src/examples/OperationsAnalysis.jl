module OperationsAnalysis
using OR.Forecast
using Printf

export example_2_1

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

end  # module OperationsAnalysis
