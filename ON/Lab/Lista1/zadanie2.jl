one16 = Float16(1.0)
three16 = Float16(3.0)
four16 = Float16(4.0)

one32 = Float32(1.0)
three32 = Float32(3.0)
four32 = Float32(4.0)

one64 = Float64(1.0)
three64 = Float64(3.0)
four64 = Float64(4.0)

ahan_eps16 = three16 * (four16 / three16 - one16) - one16
ahan_eps32 = three32 * (four32 / three32 - one32) - one32
ahan_eps64 = three64 * (four64 / three64 - one64) - one64

println("Our value 16:  ", ahan_eps16, " vs ", eps(Float16))
println("Our value 32:  ", ahan_eps32, " vs ", eps(Float32))
println("Our value 64:  ", ahan_eps64, " vs ", eps(Float64))
