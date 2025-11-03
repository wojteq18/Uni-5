using LinearAlgebra

function hilb(n::Int)
# Function generates the Hilbert matrix  A of size n,
#  A (i, j) = 1 / (i + j - 1)
# Inputs:
#	n: size of matrix A, n>=1
#
#
# Usage: hilb(10)
#
# Pawel Zielinski
        if n < 1
         error("size n should be >= 1")
        end
        return [1 / (i + j - 1) for i in 1:n, j in 1:n]
end

function matcond(n::Int, c::Float64)
# Function generates a random square matrix A of size n with
# a given condition number c.
# Inputs:
#	n: size of matrix A, n>1
#	c: condition of matrix A, c>= 1.0
#
# Usage: matcond(10, 100.0)
#
# Pawel Zielinski
        if n < 2
         error("size n should be > 1")
        end
        if c< 1.0
         error("condition number  c of a matrix  should be >= 1.0")
        end
        (U,S,V)=svd(rand(n,n))
        return U*diagm(0 =>[LinRange(1.0,c,n);])*V'
end


function hilbertMatricsErrors(n::Int)
        if n < 1
         error("size n should be >= 1")
        end

        print("Hilbert matrix")

        for i in 1:n
            H = hilb(i)
            xexact = ones(Float64, i)
            b = H * xexact

            gauss_method = H \ b
            inv_method = inv(H) * b

            gauss_method_error = norm(gauss_method - xexact) / norm(xexact)
            inv_method_error = norm(inv_method - xexact) / norm(xexact)
            print("\nSize: ", i,
                  " | Condition number: ", cond(H),
                  " | Rank number: ", rank(H),
                  " | Gauss method error: ", gauss_method_error,
                  " | Inverse method error: ", inv_method_error,
                  " | n: ", i)

        end
end  

function randomMatricsErrors(n::Int, c::Float64)
        if n < 1
                error("size n should be >= 1")
        end
        
        M = matcond(n, c)
        xexact = ones(Float64, n)
        b = M * xexact

        gauss_method = M \ b
        inv_method = inv(M) * b

        gauss_method_error = norm(gauss_method - xexact) / norm(xexact)
        inv_method_error = norm(inv_method - xexact) / norm(xexact)

        print("\nSize: ", n,
              " | Condition number: ", cond(M),
              " | Rank number: ", rank(M),
              " | Gauss method error: ", gauss_method_error,
              " | Inverse method error: ", inv_method_error,
              " | n: ", n,
              " | c: ", c)

end


_ = hilbertMatricsErrors(18)

print("\n")
n = [5, 10, 20]
c = [1, 10, 10^3, 10^7, 10^12, 10^16]
c_64 = Float64.(c)
print("Random matrix")

for i in n
        for j in c_64
                randomMatricsErrors(i, j)
        end
end
