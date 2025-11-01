# trademetrics <img src="man/figures/logo.png" align="right" height="139" alt="" />

> **Performance and Risk Analytics for Trading Strategies**

[![R-CMD-check](https://github.com/Traderverse/trademetrics/actions/workflows/R-CMD-check.yml/badge.svg)](https://github.com/Traderverse/trademetrics/actions/workflows/R-CMD-check.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Part of the **[Traderverse](https://github.com/Traderverse)** ecosystem for quantitative trading in R.

---

## 📊 Overview

**trademetrics** provides comprehensive performance and risk analytics for quantitative trading strategies. Calculate return metrics, risk-adjusted returns, drawdown analysis, rolling statistics, and more.

### Key Features

- **Return Metrics**: Total return, CAGR, annualized returns
- **Risk-Adjusted Metrics**: Sharpe, Sortino, Calmar, Information ratios
- **Drawdown Analysis**: Maximum drawdown, average drawdown, recovery time
- **Rolling Statistics**: Rolling Sharpe, volatility, correlation, beta
- **Performance Summaries**: Comprehensive reports with all key metrics

---

## 🚀 Installation

```r
# From GitHub (development version)
# install.packages("devtools")
devtools::install_github("Traderverse/trademetrics")
```

---

## 💡 Quick Start

```r
library(trademetrics)

# Sample strategy returns
returns <- rnorm(252, mean = 0.001, sd = 0.02)

# Calculate individual metrics
calc_sharpe(returns, rf_rate = 0.02/252, periods = 252)
calc_max_drawdown(returns = returns)
calc_cagr(returns = returns, periods = 252)

# Or get a comprehensive summary
summary <- performance_summary(returns, rf_rate = 0.02/252, periods = 252)
print(summary)
```

**Output:**
```
==============================================
         Performance Summary
==============================================

Return Metrics:
  Total Return:          25.30%
  CAGR:                  23.40%
  Annualized Return:     25.20%

Risk Metrics:
  Annualized Vol:        31.75%
  Sharpe Ratio:           0.79
  Sortino Ratio:          1.12
  Calmar Ratio:           1.85

Drawdown Metrics:
  Max Drawdown:         -12.65%
  Average Drawdown:      -3.45%
  Recovery Time:             45 periods

Trade Statistics:
  Total Periods:            252
  Winning Periods:          138
  Losing Periods:           114
  Win Rate:               54.76%
  Best Period:             8.23%
  Worst Period:           -7.45%

==============================================
```

---

## 📚 Main Functions

### Return Metrics
- `calc_total_return()` - Total return
- `calc_cagr()` - Compound Annual Growth Rate
- `calc_annualized_return()` - Annualized return
- `calc_annualized_volatility()` - Annualized volatility

### Risk-Adjusted Metrics
- `calc_sharpe()` - Sharpe ratio
- `calc_sortino()` - Sortino ratio
- `calc_calmar()` - Calmar ratio
- `calc_information_ratio()` - Information ratio vs benchmark

### Drawdown Analysis
- `calc_drawdown()` - Drawdown series
- `calc_max_drawdown()` - Maximum drawdown
- `calc_average_drawdown()` - Average drawdown
- `calc_drawdown_duration()` - Drawdown periods and durations
- `calc_recovery_time()` - Time to recover from max drawdown

### Rolling Statistics
- `calc_rolling_sharpe()` - Rolling Sharpe ratio
- `calc_rolling_volatility()` - Rolling volatility
- `calc_rolling_correlation()` - Rolling correlation
- `calc_rolling_beta()` - Rolling beta

### Utilities
- `performance_summary()` - Comprehensive performance report

---

## 🎓 Examples

### Compare to Benchmark

```r
# Strategy and benchmark returns
strategy_returns <- rnorm(252, 0.001, 0.02)
benchmark_returns <- rnorm(252, 0.0008, 0.015)

# Calculate Information Ratio
calc_information_ratio(strategy_returns, benchmark_returns, periods = 252)

# Include in summary
summary <- performance_summary(
  returns = strategy_returns,
  benchmark_returns = benchmark_returns,
  rf_rate = 0.02/252,
  periods = 252
)
print(summary)
```

### Rolling Metrics

```r
# Calculate rolling Sharpe ratio
rolling_sharpe <- calc_rolling_sharpe(
  returns = strategy_returns,
  window = 60,  # 3-month window
  rf_rate = 0.02/252,
  periods = 252
)

# Plot rolling Sharpe
plot(rolling_sharpe, type = "l", main = "Rolling 60-Day Sharpe Ratio")
abline(h = 0, col = "gray", lty = 2)
```

### Drawdown Analysis

```r
# Calculate drawdown series
drawdowns <- calc_drawdown(returns = strategy_returns)

# Plot drawdown
plot(drawdowns, type = "l", main = "Drawdown Over Time",
     ylab = "Drawdown %", col = "red")

# Get detailed drawdown periods
dd_periods <- calc_drawdown_duration(returns = strategy_returns)
print(dd_periods)
```

---

## 🔗 Integration with Traderverse

trademetrics works seamlessly with other Traderverse packages:

```r
library(tradeio)        # Data acquisition
library(tradefeatures)  # Technical indicators
library(tradeengine)    # Backtesting
library(trademetrics)   # Performance analytics
library(tradeviz)       # Visualization

# Fetch data
prices <- fetch_prices("AAPL", from = Sys.Date() - 365)

# Add indicators
prices <- prices |>
  add_sma(20) |>
  add_rsi(14)

# Run backtest
results <- backtest(prices, strategy = my_strategy)

# Analyze performance
summary <- performance_summary(results$returns)
print(summary)

# Visualize
plot_equity_curve(results$equity)
plot_drawdown(results$equity)
```

---

## 📖 Documentation

- [Getting Started Guide](articles/getting-started.html)
- [Function Reference](reference/index.html)
- [GitHub](https://github.com/Traderverse/trademetrics)

---

## 🤝 Contributing

We welcome contributions! See our [Contributing Guide](CONTRIBUTING.md) for details.

---

## 📜 License

MIT License. See [LICENSE](LICENSE) file for details.

---

## 🌟 Part of Traderverse

trademetrics is part of the **Traderverse** ecosystem:

- **[tradeio](https://github.com/Traderverse/tradeio)** - Data acquisition
- **[tradefeatures](https://github.com/Traderverse/tradefeatures)** - Technical indicators
- **[tradeengine](https://github.com/Traderverse/tradeengine)** - Backtesting engine
- **[trademetrics](https://github.com/Traderverse/trademetrics)** - Performance analytics ⭐ You are here
- **[tradeviz](https://github.com/Traderverse/tradeviz)** - Visualization
- **[tradedash](https://github.com/Traderverse/tradedash)** - Interactive dashboard

---

<p align="center">
  <strong>Built with ❤️ for the trading community</strong><br>
  <sub>Making quantitative trading accessible to everyone</sub>
</p>

