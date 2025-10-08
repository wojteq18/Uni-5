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
