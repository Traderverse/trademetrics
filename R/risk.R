#' Calculate Risk-Adjusted Return Metrics
#'
#' @description
#' Functions to calculate risk-adjusted performance metrics like Sharpe ratio,
#' Sortino ratio, and Calmar ratio.
#'
#' @param returns Numeric vector of returns
#' @param rf_rate Risk-free rate (default: 0)
#' @param periods Number of periods per year (default: 252 for daily data)
#' @param ... Additional arguments
#'
#' @name risk-metrics
#' @keywords internal
NULL

#' Calculate Sharpe Ratio
#'
#' @description
#' Calculate the Sharpe ratio, a measure of risk-adjusted return.
#'
#' @inheritParams risk-metrics
#'
#' @return Numeric value representing the Sharpe ratio
#'
#' @examples
#' \dontrun{
#' returns <- c(0.01, 0.02, -0.01, 0.03)
#' calc_sharpe(returns, rf_rate = 0.02/252, periods = 252)
#' }
#'
#' @export
calc_sharpe <- function(returns, rf_rate = 0, periods = 252) {
  if (length(returns) < 2) return(NA_real_)
  
  excess_returns <- returns - rf_rate
  mean_excess <- mean(excess_returns, na.rm = TRUE)
  sd_excess <- stats::sd(excess_returns, na.rm = TRUE)
  
  if (sd_excess == 0) return(NA_real_)
  
  sharpe <- (mean_excess / sd_excess) * sqrt(periods)
  sharpe
}

#' Calculate Sortino Ratio
#'
#' @description
#' Calculate the Sortino ratio, which only considers downside deviation.
#'
#' @inheritParams risk-metrics
#' @param target_return Target return (default: 0)
#'
#' @return Numeric value representing the Sortino ratio
#'
#' @examples
#' \dontrun{
#' returns <- c(0.01, 0.02, -0.01, 0.03)
#' calc_sortino(returns, rf_rate = 0.02/252, periods = 252)
#' }
#'
#' @export
calc_sortino <- function(returns, rf_rate = 0, target_return = 0, periods = 252) {
  if (length(returns) < 2) return(NA_real_)
  
  excess_returns <- returns - rf_rate
  mean_excess <- mean(excess_returns, na.rm = TRUE)
  
  # Calculate downside deviation
  downside_returns <- excess_returns[excess_returns < target_return]
  if (length(downside_returns) == 0) return(Inf)
  
  downside_dev <- sqrt(mean((downside_returns - target_return)^2, na.rm = TRUE))
  
  if (downside_dev == 0) return(NA_real_)
  
  sortino <- (mean_excess / downside_dev) * sqrt(periods)
  sortino
}

#' Calculate Calmar Ratio
#'
#' @description
#' Calculate the Calmar ratio (CAGR / Maximum Drawdown).
#'
#' @inheritParams risk-metrics
#' @param equity_curve Numeric vector of equity values
#'
#' @return Numeric value representing the Calmar ratio
#'
#' @examples
#' \dontrun{
#' equity <- c(100, 105, 110, 108, 115, 120)
#' calc_calmar(equity_curve = equity, periods = 252)
#' }
#'
#' @export
calc_calmar <- function(equity_curve = NULL, returns = NULL, periods = 252) {
  if (!is.null(equity_curve)) {
    cagr <- calc_cagr(equity_curve = equity_curve, periods = periods)
    max_dd <- calc_max_drawdown(equity_curve = equity_curve)
  } else if (!is.null(returns)) {
    cagr <- calc_cagr(returns = returns, periods = periods)
    max_dd <- calc_max_drawdown(returns = returns)
  } else {
    return(NA_real_)
  }
  
  if (is.na(max_dd) || max_dd == 0) return(NA_real_)
  
  calmar <- abs(cagr / max_dd)
  calmar
}

#' Calculate Information Ratio
#'
#' @description
#' Calculate the Information ratio compared to a benchmark.
#'
#' @inheritParams risk-metrics
#' @param benchmark_returns Numeric vector of benchmark returns
#'
#' @return Numeric value representing the Information ratio
#'
#' @examples
#' \dontrun{
#' strategy_returns <- c(0.01, 0.02, -0.01, 0.03)
#' benchmark_returns <- c(0.005, 0.015, -0.005, 0.025)
#' calc_information_ratio(strategy_returns, benchmark_returns, periods = 252)
#' }
#'
#' @export
calc_information_ratio <- function(returns, benchmark_returns, periods = 252) {
  if (length(returns) != length(benchmark_returns)) {
    stop("Returns and benchmark must have same length")
  }
  if (length(returns) < 2) return(NA_real_)
  
  active_returns <- returns - benchmark_returns
  mean_active <- mean(active_returns, na.rm = TRUE)
  tracking_error <- stats::sd(active_returns, na.rm = TRUE)
  
  if (tracking_error == 0) return(NA_real_)
  
  ir <- (mean_active / tracking_error) * sqrt(periods)
  ir
}
