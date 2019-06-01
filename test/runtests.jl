using Test
using OR.Forecast

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
