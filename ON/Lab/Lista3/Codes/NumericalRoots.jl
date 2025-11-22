module NumericalRoots

export mbisekcji, mstycznych, msiecznych

function mbisekcji(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64)
    u = f(a)
    v = f(b)
    err = 0
    if u * v > 0
        err = 1
        return 0.0, 0.0, 0, err
    end
    e = abs(b - a)
    c = a 
    for k in 1:1000
        e = e / 2
        c = a + e
        w = f(c)

        if abs(e) < delta || abs(w) < epsilon
            return c, w, k, err 
        end   
        
        if w * u < 0
            b = c
            v = w 

        else 
            a = c 
            u = w    
        end    
    end
    return c, f(c), 1000, err
end

function mstycznych(f,pf,x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    v = f(x0)

    if abs(v) < epsilon
        return x0, v, 0, 0
    end
    
    for it in 1:maxit 
        pv = pf(x0)

        if abs(pv) < epsilon
            return x0, v, it, 2
        end

        x1 = x0 - v / pv
        v = f(x1)

        if abs(x1 - x0) < delta || abs(v) < epsilon
            return x1, v, it, 0
        end

        x0 = x1
    end    

    return x0, v, maxit, 1
end   

function msiecznych(f, x0::Float64, x1::Float64, delta::Float64, epsilon::Float64,maxit::Int)
    fa = f(x0)
    fb = f(x1)

    for k in 1:maxit 
        if abs(fa) > abs(fb)
            x0, x1 = x1, x0
            fa, fb = fb, fa
        end

        if abs(fb - fa) < epsilon
            return x1, fb, k, 0 # Zwracamy ostatnie lepsze przybliżenie
        end
        s = (x1 - x0) / (fb - fa)
        x_new = x0 - fa * s
        f_new = f(x_new)

        if abs(x_new - x0) < delta || abs(f_new) < epsilon
            return x_new, f_new, k, 0
        end

        x1 = x0
        fb = fa
        x0 = x_new
        fa = f_new
    end    
    return x0, fa, maxit, 1
end   

end # module NumericalRoots