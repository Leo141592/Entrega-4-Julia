# =========================
# 📦 DATOS BASE
# =========================

ratings = Dict(
    "Ana" => Dict("Matrix"=>5, "Titanic"=>3, "Avatar"=>4),
    "Luis" => Dict("Matrix"=>4, "Titanic"=>2, "Avatar"=>5, "Inception"=>5, "Interstellar"=>4),
    "Maria" => Dict("Matrix"=>5, "Avatar"=>4, "Inception"=>4, "Interstellar"=>5),
    "Pedro" => Dict("Titanic"=>5, "Inception"=>3, "Gladiator"=>4)
)

# =========================
# 📊 SIMILITUD
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
# 🎯 RECOMENDADOR
# =========================

function recomendar(ratings, usuario_nuevo)
    scores = Dict{String, Float64}()
    pesos = Dict{String, Float64}()

    for (otro, data) in ratings
        sim = similitud(usuario_nuevo, data)

        for (pelicula, rating) in data
            if !(pelicula in keys(usuario_nuevo))
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
# 👤 INPUT DEL USUARIO
# =========================

println("🎬 Escribe tus 3 películas favoritas:")

favoritas = Dict{String, Float64}()

for i in 1:3
    print("Película $i: ")
    pelicula = readline()
    favoritas[pelicula] = 5.0   # rating alto
end

# =========================
# 🚀 RESULTADOS
# =========================

recs = recomendar(ratings, favoritas)

println("\n🔥 Recomendaciones para ti:")
for (pelicula, score) in recs[1:min(5, length(recs))]
    println("👉 $pelicula (score: $(round(score, digits=2)))")
end