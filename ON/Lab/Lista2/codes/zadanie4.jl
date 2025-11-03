using Polynomials
using Printf 

coeffs = [
    1.0, -210.0 - 2^-23, 20615.0, -1256850.0,
    53327946.0, -1672280820.0, 40171771630.0, -756111184500.0,
    11310276995381.0, -135585182899530.0,
    1307535010540395.0, -10142299865511450.0,
    63030812099294896.0, -311333643161390640.0,
    1206647803780373360.0, -3599979517947607200.0,
    8037811822645051776.0, -12870931245150988800.0,
    13803759753640704000.0, -8752948036761600000.0,
    2432902008176640000.0
]

coeffs_reversed = reverse(coeffs)

wilkinsonNaturalForm = Polynomial(coeffs_reversed)


function wilkinsonPolynomial(x)
    result = 1.0
    for k in 1:20
        result *= (x - k)
    end
    return result
end



rootsOfP = roots(wilkinsonNaturalForm) # Oblicza pierwiastki wielomianu P
println("Pierwiastki wielomianu P: ", rootsOfP)
sorted_roots = sort(rootsOfP, by=real)

for (k, root) in enumerate(sorted_roots)
    value_in_polynomial = abs(wilkinsonPolynomial(root))

    value_in_natural_form = abs(wilkinsonNaturalForm(root))

    error = abs(root - k)
    @printf("k=%2d | zk ≈ %-25s | |p(zk)|=%.2e | |P(zk)|=%.2e | |zk-k|=%.4f\n", 
            k, string(round(root, digits=4)), value_in_polynomial, value_in_natural_form, error)

end
