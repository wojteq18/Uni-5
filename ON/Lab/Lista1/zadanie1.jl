function eps16()
    kandydat1 = Float16(1.0)
    while Float16(1.0) + (kandydat1 / Float16(2.0)) > Float16(1.0)
        kandydat1 /= Float16(2.0)
    end
    return kandydat1
end

function eps32()
    kandydat1 = Float32(1.0)
    while Float32(1.0) + (kandydat1 / Float32(2.0)) > Float32(1.0)
        kandydat1 /= Float32(2.0)
    end
    return kandydat1
end

function eps64()
    kandydat1 = Float64(1.0)
    while Float64(1.0) + (kandydat1 / Float64(2.0)) > Float64(1.0)
        kandydat1 /= Float64(2.0)
    end
    return kandydat1
end

function eta16()
    kandydat = Float16(1.0)
    while kandydat / Float16(2.0) > Float16(0.0)
        kandydat /= Float16(2.0)
    end
    return kandydat
end

function eta32()
    kandydat = Float32(1.0)
    while kandydat / Float32(2.0) > Float32(0.0)
        kandydat /= Float32(2.0)
    end
    return kandydat
end

function eta64()
    kandydat = Float64(1.0)
    while kandydat / Float64(2.0) > Float64(0.0)
        kandydat /= Float64(2.0)
    end
    return kandydat
end

function max16()
    kandydat = Float16(1.0)
    ostatni = Float16(1.0)
    while !isinf(kandydat)
        ostatni = kandydat
        kandydat *= Float16(2.0)
    end    

    krok = ostatni / Float16(2.0)
    while krok > Float16(0.0)
        if !isinf(ostatni + krok)
            ostatni += krok
        end
        krok /= Float16(2.0)
    end
    return ostatni
end

function max32()
    kandydat = Float32(1.0)
    ostatni = Float32(1.0)
    while !isinf(kandydat)
        ostatni = kandydat
        kandydat *= Float32(2.0)
    end    

    krok = ostatni / Float32(2.0)
    while krok > Float32(0.0)
        if !isinf(ostatni + krok)
            ostatni += krok
        end
        krok /= Float32(2.0)
    end
    return ostatni
end

function max64()
    kandydat = Float64(1.0)
    ostatni = Float64(1.0)
    while !isinf(kandydat)
        ostatni = kandydat
        kandydat *= Float64(2.0)
    end    

    krok = ostatni / Float64(2.0)
    while krok > Float64(0.0)
        if !isinf(ostatni + krok)
            ostatni += krok
        end
        krok /= Float64(2.0)
    end
    return ostatni
end

    

our_value16 = eps16()
println("Our value:  ", our_value16)

real_value16 = eps(Float16)

println("Real value: ", real_value16)

our_value32 = eps32()
println("Our value:  ", our_value32)

real_value32 = eps(Float32)

println("Real value: ", real_value32)

our_value64 = eps64()
println("Our value:  ", our_value64)

real_value64 = eps(Float64)

println("Real value: ", real_value64)

our_value_eta16 = eta16()
println("Our value:  ", our_value_eta16)

real_value_eta16 = nextfloat(Float16(0.0))
println("Real value: ", real_value_eta16)

our_value_eta32 = eta32()
println("Our value:  ", our_value_eta32)

real_value_eta32 = nextfloat(Float32(0.0))
println("Real value: ", real_value_eta32)

our_value_eta64 = eta64()
println("Our value:  ", our_value_eta64)

real_value_eta64 = nextfloat(Float64(0.0))
println("Real value: ", real_value_eta64)

float_min_32 = floatmin(Float32)
println("Float32 min value: ", float_min_32)

float_min_64 = floatmin(Float64)
println("Float64 min value: ", float_min_64)

max_16 = max16()
println("Our value:  ", max_16)

real_max_16 = floatmax(Float16)
println("Real value: ", real_max_16)

max_32 = max32()
println("Our value:  ", max_32)

real_max_32 = floatmax(Float32)
println("Real value: ", real_max_32)

max_64 = max64()
println("Our value:  ", max_64)

real_max_64 = floatmax(Float64)
println("Real value: ", real_max_64)
