function receq(n::Int, p0, r)
    p = p0 
    for i in 1:n
        p = p + r * p * (1 - p)
        println("Krok $i: p = $p")
    end
    return p
end

#Funkcja do obcinania liczby zmiennoprzecinkowej do n miejsc po przecinku
function truncate_decimal(x::Real, n::Int)
    factor = 10.0^n
    return trunc(x * factor) / factor
end

r::Float64 = 3.0
n_prev = 10
p0_prev::Float64 = 0.01
p0::Float64 = receq(n_prev, p0_prev, r)
p0 = truncate_decimal(p0, 3)
print("p0: ", p0, "\n")
n::Int = 30
result = receq(n, p0, r)
println("Dla n = $n oraz r = $r, otrzymujemy x_n = $result")

result_pointa = receq(40, p0_prev, r)
println("Dla n = 40 oraz r = $r, otrzymujemy x_n = $result_pointa")