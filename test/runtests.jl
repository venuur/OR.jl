using Test
using OR.Forecast

function test_forecast_error()
    test_yhat = [
    [92, 87, 95, 90, 88, 93],
    [96, 89, 92, 93, 90, 85]
    ]
    test_y = [
    [88, 88, 97, 83, 91, 93],
    [91, 89, 90, 90, 86, 89]
    ]
    test_e = test_yhat .- test_y
    expected_mad = [2.83, 3.0]
    expected_mse = [13.17, 11.67]
    expected_mape = [3.25, 3.37]
    ex_atol = 0.005

    test_seq = zip(test_y, test_e, expected_mad, expected_mse, expected_mape)
    for (y, e, ex_mad, ex_mse, ex_mape) in test_seq
        @test mad(e) ≈ ex_mad atol=ex_atol
        @test mse(e) ≈ ex_mse atol=ex_atol
        @test mape(e, y) ≈ ex_mape atol=ex_atol
    end
end

function test_moving_average()
    test_y = [200, 250, 175, 186, 225, 285, 305, 190]
    ex_ma3 = [208.3, 203.7, 195.3, 232.0, 271.7]
    ex_ma6 = [220.2, 237.7]
    ma3 = ma(test_y, 3)
    ma6 = ma(test_y, 6)
    ex_atol = 0.05
    for (yhat, ex_yhat) in zip(ma3, ex_ma3)
        @test yhat ≈ ex_yhat atol=ex_atol
    end
    for (yhat, ex_yhat) in zip(ma6, ex_ma6)
        @test yhat ≈ ex_yhat atol=ex_atol
    end
end

function test_exponential_smoothing()
    test_y = [200, 250, 175, 186, 225, 285, 305, 190]
    ex_es = [200.0, 205.0, 202.0, 200.4, 202.9, 211.1, 220.5]
    α = 0.1
    es_yhat = es(test_y, test_y[1], α)
    ex_atol = 0.05
    for (yhat, ex_yhat) in zip(es_yhat, ex_es)
        @test yhat ≈ ex_yhat atol=ex_atol
    end
end

function test_linear_regression()
    test_y = [200, 250, 175, 186, 225]
    ex_a = 211.4
    ex_b = -1.4

    a, b = lr(test_y)

    ex_atol = 0.05
    @test a ≈ ex_a atol=ex_atol
    @test b ≈ ex_b atol=ex_atol
end

function test_double_exponential_smoothing()
    test_y = [200, 250, 175, 186, 225, 285, 305, 190]
    ex_s = [209.0, 222.0, 226.5, 231.1, 238.7, 251.4, 265.2]
    ex_g = [9.9, 10.21, 9.64, 9.14, 8.98, 9.36, 9.8]
    g0 = 10.0
    α = 0.1
    β = 0.1

    s, g = es2(test_y, test_y[1], g0, α, β)

    ex_atol = 0.05
    for (si, gi, ex_si, ex_gi) in zip(s, g, ex_s, ex_g)
        @test si ≈ ex_si atol=ex_atol
        @test gi ≈ ex_gi atol=ex_atol
    end
end

test_forecast_error()
test_moving_average()
test_exponential_smoothing()
test_linear_regression()
test_double_exponential_smoothing()
