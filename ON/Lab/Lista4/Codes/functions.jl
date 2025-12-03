module functions

    using Plots

    export ilorazyRoznicowe, warNewton, naturalna, rysujNnfx 

    function ilorazyRoznicowe(x::Vector{Float64}, f::Vector{Float64})
        n = length(f) - 1 
        fx = copy(f)

        for j in 1:n
            for i in n+1:-1:(j+1)
                licznik = fx[i] - fx[i-1]
                mianownik = x[i] - x[i-j]
                fx[i] = licznik / mianownik
            end
        end
        return fx
    end

    function warNewton(x::Vector{Float64}, fx::Vector{Float64}, t::Float64)
        n = length(fx) - 1 
        nt = fx[n+1]
        for i in n:-1:1
            nt = fx[i] + (t - x[i]) * nt
        end
        return nt
    end

    function naturalna(x::Vector{Float64}, fx::Vector{Float64})
        n = length(fx) - 1 
        a = copy(fx)
        for k in n:-1:1
            for j in k:n 
                a[j] = a[j] - a[j+1] * x[k]
            end
        end   
        return a      
    end    

    function rysujNnfx(f, a::Float64, b::Float64, n::Int; wezly::Symbol = :rownoodlegle)
        x_nodes = Vector{Float64}(undef, n+1)

        if wezly == :rownoodlegle
            h = (b - a) / n
            for k in 0:n
                x_nodes[k+1] = a + k * h
            end
        elseif wezly == :czebyszew
            for k in 1:(n+1)
                x_raw = cos( (2*k - 1) * pi / (2 * (n+1)))
                x_nodes[k] = 0.5 * (a + b) + 0.5 * (b - a) * x_raw
            end
        else
            error("Nieznany typ węzłów: $wezly")
        end
        
        y_nodes = f.(x_nodes)
        coeffs = ilorazyRoznicowe(x_nodes, y_nodes)
        
        x_plot = range(a, stop=b, length=1000)
        y_true = f.(x_plot)
        y_interp = [warNewton(x_nodes, coeffs, t) for t in x_plot]

        plt = plot(x_plot, y_true, label="f(x)", lw=2)
        plot!(plt, x_plot, y_interp, label="N_n(x)", lw=2, ls=:dash)
        scatter!(plt, x_nodes, y_nodes, label="Węzły interpolacji", ms=4, mc=:red)
        xlabel!("x")
        ylabel!("y")
        title!("Interpolacja Newtona stopnia $n")
        display(plt)
    end

end # module functions