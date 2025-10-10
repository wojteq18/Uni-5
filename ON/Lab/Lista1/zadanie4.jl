function find_number() # subpoint a
    while true
        random_number = 1.0 + rand()
        if random_number * (Float64(1.0) / random_number) != 1.0
            return random_number
            break
        end
    end
end        

function find_min_number() # subpoint b
    min_number = nextfloat(1.0)
    while true
        if min_number * (Float64(1.0) / min_number) != 1.0
            return min_number
            break
        end
        min_number = nextfloat(min_number)
    end
end


number = find_number()
println("Found number: ", number)

min_number = find_min_number()
println("Found min number: ", min_number)