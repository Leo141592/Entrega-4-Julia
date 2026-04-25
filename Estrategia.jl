using Statistics
using Plots

# =========================
# 📦 ESTRUCTURA
# =========================
struct Accion
    nombre::String
    precios::Vector{Float64}
end

# =========================
# 📊 INDICADORES
# =========================

function SMA(precios, n)
    return [mean(precios[i-n+1:i]) for i in n:length(precios)]
end

function EMA(precios, n)
    α = 2 / (n + 1)
    ema = [precios[1]]
    for i in 2:length(precios)
        push!(ema, α * precios[i] + (1 - α) * ema[end])
    end
    return ema
end

function RSI(precios, n=14)
    ganancias = Float64[]
    perdidas = Float64[]

    for i in 2:length(precios)
        cambio = precios[i] - precios[i-1]
        push!(ganancias, max(cambio, 0))
        push!(perdidas, abs(min(cambio, 0)))
    end

    rsis = Float64[]
    for i in n:length(ganancias)
        avg_gain = mean(ganancias[i-n+1:i])
        avg_loss = mean(perdidas[i-n+1:i])
        rs = avg_gain / (avg_loss + 1e-6)
        rsi = 100 - (100 / (1 + rs))
        push!(rsis, rsi)
    end

    return rsis
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

    señales = String[]
    idxs = Int[]

    n = minimum([length(sma), length(rsi), length(macd)])

    for i in 1:n
        if rsi[i] < 30 && macd[i] > signal[i]
            push!(señales, "BUY")
        elseif rsi[i] > 70 && macd[i] < signal[i]
            push!(señales, "SELL")
        else
            push!(señales, "HOLD")
        end
        push!(idxs, i)
    end

    return señales, idxs, sma, rsi, macd, signal
end

# =========================
# 💰 BACKTESTING
# =========================
function backtest(precios, señales, idxs; capital_inicial=100.0)
    capital = capital_inicial
    acciones = 0.0
    historial = Float64[]

    for i in 1:length(señales)
        precio = precios[i]

        if señales[i] == "BUY" && capital > 0
            acciones = capital / precio
            capital = 0.0
        elseif señales[i] == "SELL" && acciones > 0
            capital = acciones * precio
            acciones = 0.0
        end

        total = capital + acciones * precio
        push!(historial, total)
    end

    return historial
end

# =========================
# 📊 DATOS (puedes cambiar por reales)
# =========================
precios_tsla = [
    250, 252, 249, 255, 260, 258, 262, 265, 270, 268,
    272, 275, 278, 280, 277, 282, 285, 290, 288, 295,
    300, 305, 310, 308, 315, 320, 318, 325, 330, 335
]

tsla = Accion("TSLA", precios_tsla)

# =========================
# 🚀 EJECUCIÓN
# =========================
señales, idxs, sma, rsi, macd, signal = estrategia(tsla.precios)
capital = backtest(tsla.precios, señales, idxs)

# =========================
# 📉 GRÁFICAS
# =========================

# Precio + SMA + señales
p1 = plot(tsla.precios, label="Precio", title="Precio TSLA + Señales")
plot!(p1, 10:length(tsla.precios), sma, label="SMA(10)")

for i in 1:length(señales)
    if señales[i] == "BUY"
        scatter!(p1, [i], [tsla.precios[i]], label="", markershape=:triangle, markersize=6)
    elseif señales[i] == "SELL"
        scatter!(p1, [i], [tsla.precios[i]], label="", markershape=:utriangle, markersize=6)
    end
end

# RSI
p2 = plot(rsi, label="RSI", title="RSI")
hline!(p2, [30, 70])

# Capital
p3 = plot(capital, label="Capital", title="Backtesting ($100 inicial)")

plot(p1, p2, p3, layout=(3,1))