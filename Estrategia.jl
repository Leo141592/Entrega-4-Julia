using Statistics

# =========================
# 📦 ESTRUCTURA DE DATOS
# =========================
struct Accion
    nombre::String
    precios::Vector{Float64}
end

# =========================
# 📊 INDICADORES
# =========================

# Media móvil simple
function SMA(precios, n)
    return [mean(precios[i-n+1:i]) for i in n:length(precios)]
end

# RSI
function RSI(precios, n=14)
    ganancias = []
    perdidas = []

    for i in 2:length(precios)
        cambio = precios[i] - precios[i-1]
        push!(ganancias, max(cambio, 0))
        push!(perdidas, abs(min(cambio, 0)))
    end

    rsis = []
    for i in n:length(ganancias)
        avg_gain = mean(ganancias[i-n+1:i])
        avg_loss = mean(perdidas[i-n+1:i])
        rs = avg_gain / (avg_loss + 1e-6)
        rsi = 100 - (100 / (1 + rs))
        push!(rsis, rsi)
    end

    return rsis
end

# MACD
function EMA(precios, n)
    α = 2 / (n + 1)
    ema = [precios[1]]
    for i in 2:length(precios)
        push!(ema, α * precios[i] + (1 - α) * ema[end])
    end
    return ema
end

function MACD(precios)
    ema12 = EMA(precios, 12)
    ema26 = EMA(precios, 26)
    macd = ema12 .- ema26
    signal = EMA(macd, 9)
    return macd, signal
end

# =========================
# 📈 ESTRATEGIA
# =========================
function estrategia(precios)
    sma = SMA(precios, 10)
    rsi = RSI(precios)
    macd, signal = MACD(precios)

    señales = []

    for i in 1:min(length(sma), length(rsi), length(macd))
        if rsi[i] < 30 && macd[i] > signal[i]
            push!(señales, ("BUY", i))
        elseif rsi[i] > 70 && macd[i] < signal[i]
            push!(señales, ("SELL", i))
        else
            push!(señales, ("HOLD", i))
        end
    end

    return señales
end

# =========================
# 🚀 EJECUCIÓN
# =========================

# Datos simulados (puedes reemplazar con reales)
precios_tsla = [
    250, 252, 249, 255, 260, 258, 262, 265, 270, 268,
    272, 275, 278, 280, 277, 282, 285, 290, 288, 295
]

tsla = Accion("TSLA", precios_tsla)

señales = estrategia(tsla.precios)

# Mostrar resultados
for s in señales
    println(s)
end