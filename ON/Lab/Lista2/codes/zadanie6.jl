function receq(n::Int, c::Int, x0::Float64)
    start_value = x0
    for i in 1:n
        x0 = x0 * x0 + c
        println("Krok $i: x = $x0, c = $c, x0 = $start_value")
    end
    return x0
end

n = 40
c1 = -2
x01 = 1.0
x02 = 2.0
x03 = 1.99999999999999

c2 = -1
x04 = -1.0
x05 = 0.75
x06 = 0.25

result1 = receq(n, c1, x01)
result2 = receq(n, c1, x02)
result3 = receq(n, c1, x03)

result4 = receq(n, c2, x01)
result5 = receq(n, c2, x04)
result6 = receq(n, c2, x05)
result7 = receq(n, c2, x06)
