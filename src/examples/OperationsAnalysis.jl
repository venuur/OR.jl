module OperationsAnalysis
using OR.Forecast

export example_2_1

"""
    example_2_1()



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
end

end  # module OperationsAnalysis
