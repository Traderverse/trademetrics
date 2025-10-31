#' Calculate Return Metrics
#'
#' @description
#' Functions to calculate various return metrics for trading strategies.
#'
#' @param returns Numeric vector of returns
#' @param equity_curve Numeric vector of equity values
#' @param periods Number of periods per year (252 for daily, 12 for monthly, etc.)
#' @param ... Additional arguments
#'
#' @name return-metrics
#' @keywords internal
NULL

#' Calculate Total Return
#'
#' @description
#' Calculate the total return of a strategy.
#'
#' @inheritParams return-metrics
#'
#' @return Numeric value representing total return as a decimal (e.g., 0.25 = 25%)
#'
#' @examples
#' \dontrun{
#' returns <- c(0.01, 0.02, -0.01, 0.03)
#' calc_total_return(returns)
#' }
#'
#' @export
calc_total_return <- function(returns) {
  if (length(returns) == 0) return(NA_real_)
  prod(1 + returns) - 1
}

#' Calculate Compound Annual Growth Rate (CAGR)
#'
#' @description
#' Calculate the Compound Annual Growth Rate of a strategy.
#'
#' @inheritParams return-metrics
#' @param periods Number of periods per year (default: 252 for daily data)
#'
#' @return Numeric value representing CAGR as a decimal
#'
#' @examples
#' \dontrun{
#' equity <- c(100, 105, 110, 108, 115)
#' calc_cagr(equity_curve = equity, periods = 252)
#' }
#'
#' @export
calc_cagr <- function(equity_curve = NULL, returns = NULL, periods = 252) {
  if (!is.null(equity_curve)) {
    if (length(equity_curve) < 2) return(NA_real_)
    n_years <- length(equity_curve) / periods
    total_return <- equity_curve[length(equity_curve)] / equity_curve[1]
    cagr <- total_return^(1/n_years) - 1
    return(cagr)
  }
  
  if (!is.null(returns)) {
    if (length(returns) == 0) return(NA_real_)
    n_years <- length(returns) / periods
    total_return <- prod(1 + returns)
    cagr <- total_return^(1/n_years) - 1
    return(cagr)
  }
  
  NA_real_
}

#' Calculate Annualized Return
#'
#' @description
#' Calculate the annualized return of a strategy.
#'
#' @inheritParams return-metrics
#' @param periods Number of periods per year (default: 252 for daily data)
#'
#' @return Numeric value representing annualized return as a decimal
#'
#' @examples
#' \dontrun{
#' returns <- c(0.01, 0.02, -0.01, 0.03)
#' calc_annualized_return(returns, periods = 252)
#' }
#'
#' @export
calc_annualized_return <- function(returns, periods = 252) {
  if (length(returns) == 0) return(NA_real_)
  mean_return <- mean(returns, na.rm = TRUE)
  annualized <- mean_return * periods
  annualized
}

#' Calculate Annualized Volatility
#'
#' @description
#' Calculate the annualized volatility (standard deviation) of returns.
#'
#' @inheritParams return-metrics
#' @param periods Number of periods per year (default: 252 for daily data)
#'
#' @return Numeric value representing annualized volatility as a decimal
#'
#' @examples
#' \dontrun{
#' returns <- c(0.01, 0.02, -0.01, 0.03)
#' calc_annualized_volatility(returns, periods = 252)
#' }
#'
#' @export
calc_annualized_volatility <- function(returns, periods = 252) {
  if (length(returns) < 2) return(NA_real_)
  vol <- stats::sd(returns, na.rm = TRUE)
  annualized_vol <- vol * sqrt(periods)
  annualized_vol
}
