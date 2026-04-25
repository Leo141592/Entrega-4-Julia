# =========================
# 📦 DATOS
# =========================

ratings = Dict(
    "Ana" => Dict("Matrix"=>5, "Titanic"=>3, "Avatar"=>4),
    "Luis" => Dict("Matrix"=>4, "Titanic"=>2, "Avatar"=>5, "Inception"=>5),
    "Maria" => Dict("Matrix"=>5, "Avatar"=>4, "Inception"=>4),
    "Pedro" => Dict("Titanic"=>5, "Inception"=>3)
)

# =========================
# 📊 SIMILITUD (coseno)
# =========================

function similitud(u1, u2)
    comunes = intersect(keys(u1), keys(u2))
    
    if length(comunes) == 0
        return 0.0
    end

    num = sum(u1[p]*u2[p] for p in comunes)
    den1 = sqrt(sum(u1[p]^2 for p in comunes))
    den2 = sqrt(sum(u2[p]^2 for p in comunes))

    return num / (den1 * den2 + 1e-6)
end

# =========================
# 🔍 USUARIOS SIMILARES
# =========================

function usuarios_similares(ratings, usuario)
    sims = Dict()

    for (otro, data) in ratings
        if otro != usuario
            sims[otro] = similitud(ratings[usuario], data)
        end
    end

    return sort(collect(sims), by = x -> -x[2])
end

# =========================
# 🎯 RECOMENDACIONES
# =========================

function recomendar(ratings, usuario)
    similares = usuarios_similares(ratings, usuario)
    vistos = Set(keys(ratings[usuario]))

    scores = Dict{String, Float64}()
    pesos = Dict{String, Float64}()

    for (otro, sim) in similares
        for (pelicula, rating) in ratings[otro]
            if !(pelicula in vistos)
                scores[pelicula] = get(scores, pelicula, 0.0) + sim * rating
                pesos[pelicula] = get(pesos, pelicula, 0.0) + sim
            end
        end
    end

    recomendaciones = Dict()

    for pelicula in keys(scores)
        recomendaciones[pelicula] = scores[pelicula] / (pesos[pelicula] + 1e-6)
    end

    return sort(collect(recomendaciones), by = x -> -x[2])
end

# =========================
# 🚀 USO
# =========================

println("Usuarios similares a Ana:")
println(usuarios_similares(ratings, "Ana"))

println("\nRecomendaciones para Ana:")
println(recomendar(ratings, "Ana"))