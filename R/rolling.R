#' Calculate Rolling Metrics
#'
#' @description
#' Functions to calculate rolling (moving window) statistics.
#'
#' @param returns Numeric vector of returns
#' @param window Window size for rolling calculation
#' @param ... Additional arguments
#'
#' @name rolling-metrics
#' @keywords internal
NULL

#' Calculate Rolling Sharpe Ratio
#'
#' @description
#' Calculate a rolling (moving window) Sharpe ratio.
#'
#' @inheritParams rolling-metrics
#' @param rf_rate Risk-free rate (default: 0)
#' @param periods Number of periods per year (default: 252)
#' @param min_periods Minimum periods required for calculation (default: window)
#'
#' @return Numeric vector of rolling Sharpe ratios
#'
#' @examples
#' \dontrun{
#' returns <- rnorm(100, 0.001, 0.02)
#' rolling_sharpe <- calc_rolling_sharpe(returns, window = 20)
#' }
#'
#' @export
calc_rolling_sharpe <- function(returns, window = 20, rf_rate = 0, periods = 252, min_periods = NULL) {
  if (is.null(min_periods)) min_periods <- window
  
  n <- length(returns)
  rolling_sharpe <- rep(NA_real_, n)
  
  for (i in window:n) {
    window_returns <- returns[(i - window + 1):i]
    if (length(window_returns) >= min_periods) {
      rolling_sharpe[i] <- calc_sharpe(window_returns, rf_rate = rf_rate, periods = periods)
    }
  }
  
  rolling_sharpe
}

#' Calculate Rolling Volatility
#'
#' @description
#' Calculate rolling (moving window) volatility.
#'
#' @inheritParams rolling-metrics
#' @param periods Number of periods per year (default: 252)
#' @param min_periods Minimum periods required for calculation (default: 2)
#'
#' @return Numeric vector of rolling volatility values
#'
#' @examples
#' \dontrun{
#' returns <- rnorm(100, 0.001, 0.02)
#' rolling_vol <- calc_rolling_volatility(returns, window = 20)
#' }
#'
#' @export
calc_rolling_volatility <- function(returns, window = 20, periods = 252, min_periods = 2) {
  n <- length(returns)
  rolling_vol <- rep(NA_real_, n)
  
  for (i in window:n) {
    window_returns <- returns[(i - window + 1):i]
    if (length(window_returns) >= min_periods) {
      rolling_vol[i] <- calc_annualized_volatility(window_returns, periods = periods)
    }
  }
  
  rolling_vol
}

#' Calculate Rolling Correlation
#'
#' @description
#' Calculate rolling correlation between two return series.
#'
#' @inheritParams rolling-metrics
#' @param returns2 Second numeric vector of returns
#' @param min_periods Minimum periods required for calculation (default: window)
#'
#' @return Numeric vector of rolling correlation values
#'
#' @examples
#' \dontrun{
#' returns1 <- rnorm(100, 0.001, 0.02)
#' returns2 <- rnorm(100, 0.0008, 0.015)
#' rolling_corr <- calc_rolling_correlation(returns1, returns2, window = 20)
#' }
#'
#' @export
calc_rolling_correlation <- function(returns, returns2, window = 20, min_periods = NULL) {
  if (length(returns) != length(returns2)) {
    stop("Both return series must have the same length")
  }
  
  if (is.null(min_periods)) min_periods <- window
  
  n <- length(returns)
  rolling_corr <- rep(NA_real_, n)
  
  for (i in window:n) {
    window_returns1 <- returns[(i - window + 1):i]
    window_returns2 <- returns2[(i - window + 1):i]
    
    if (length(window_returns1) >= min_periods) {
      rolling_corr[i] <- stats::cor(window_returns1, window_returns2, use = "complete.obs")
    }
  }
  
  rolling_corr
}

#' Calculate Rolling Beta
#'
#' @description
#' Calculate rolling beta relative to a benchmark.
#'
#' @inheritParams rolling-metrics
#' @param benchmark_returns Numeric vector of benchmark returns
#' @param min_periods Minimum periods required for calculation (default: window)
#'
#' @return Numeric vector of rolling beta values
#'
#' @examples
#' \dontrun{
#' strategy_returns <- rnorm(100, 0.001, 0.02)
#' benchmark_returns <- rnorm(100, 0.0008, 0.015)
#' rolling_beta <- calc_rolling_beta(strategy_returns, benchmark_returns, window = 20)
#' }
#'
#' @export
calc_rolling_beta <- function(returns, benchmark_returns, window = 20, min_periods = NULL) {
  if (length(returns) != length(benchmark_returns)) {
    stop("Returns and benchmark must have the same length")
  }
  
  if (is.null(min_periods)) min_periods <- window
  
  n <- length(returns)
  rolling_beta <- rep(NA_real_, n)
  
  for (i in window:n) {
    window_returns <- returns[(i - window + 1):i]
    window_benchmark <- benchmark_returns[(i - window + 1):i]
    
    if (length(window_returns) >= min_periods) {
      covar <- stats::cov(window_returns, window_benchmark, use = "complete.obs")
      var_benchmark <- stats::var(window_benchmark, na.rm = TRUE)
      
      if (var_benchmark > 0) {
        rolling_beta[i] <- covar / var_benchmark
      }
    }
  }
  
  rolling_beta
}
