function one_two_bitstring()
    i = Float64(1.0)
    next_i = nextfloat(i)
    println("Number 1 in bitstring: ", bitstring(i))
    println("Next number in bitstring: ", bitstring(next_i))

    if next_i - i == 2.0^(-52)
        println("The difference is equal to 2^-52")
    else
        println("The difference is not equal to 2^-52")
    end

    for _ in 1:1000
        rand_number = 1.0 + rand()
        next_rand_number = nextfloat(rand_number)
        if next_rand_number - rand_number != 2.0^(-52)
            println("Found a number where the difference is not equal to 2^-52: ", rand_number)
            break
        end

    end
end

function half_one_bitstring()
    i = Float64(0.5)
    next_i = nextfloat(i)
    println("Number 0.5 in bitstring: ", bitstring(i))
    println("Next number in bitstring: ", bitstring(next_i))

    println("The difference is equal to: ", next_i - i, " And 2^- 53 is equal to: ", 2.0^(-53))

    for _ in 1:1000
        rand_number = (1.0 + rand()) / 2.0
        next_rand_number = nextfloat(rand_number)
        if next_rand_number - rand_number != 2.0^(-53)
            println("Found a number where the difference is not equal to 2^-53: ", rand_number)
            break
        end

    end
end

function two_four_bitstring()
    i = Float64(2.0)
    next_i = nextfloat(i)
    println("Number 2 in bitstring: ", bitstring(i))
    println("Next number in bitstring: ", bitstring(next_i))

    if next_i - i == 2.0^(-51)
        println("The difference is equal to 2^-51")
    else
        println("The difference is not equal to 2^-51")
    end

    for _ in 1:1000
        rand_number = (1.0 + rand()) * 2.0
        next_rand_number = nextfloat(rand_number)
        if next_rand_number - rand_number != 2.0^(-51)
            println("Found a number where the difference is not equal to 2^-51: ", rand_number)
            break
        end

    end
end

_ = one_two_bitstring()
_ = half_one_bitstring()
_ = two_four_bitstring()