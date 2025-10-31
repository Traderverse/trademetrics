#' Utility Functions
#'
#' @description
#' Helper functions for trademetrics package.
#'
#' @name utils
#' @keywords internal
NULL

#' Generate Performance Summary
#'
#' @description
#' Generate a comprehensive performance summary with all key metrics.
#'
#' @param returns Numeric vector of returns
#' @param equity_curve Numeric vector of equity values
#' @param benchmark_returns Optional benchmark returns for comparison
#' @param rf_rate Risk-free rate (default: 0)
#' @param periods Number of periods per year (default: 252)
#'
#' @return List containing all performance metrics
#'
#' @examples
#' \dontrun{
#' returns <- rnorm(252, 0.001, 0.02)
#' summary <- performance_summary(returns)
#' }
#'
#' @export
performance_summary <- function(returns, equity_curve = NULL, benchmark_returns = NULL, 
                                rf_rate = 0, periods = 252) {
  
  # Calculate equity curve if not provided
  if (is.null(equity_curve)) {
    equity_curve <- cumprod(1 + returns) * 100
  }
  
  summary <- list(
    # Return metrics
    total_return = calc_total_return(returns),
    cagr = calc_cagr(returns = returns, periods = periods),
    annualized_return = calc_annualized_return(returns, periods = periods),
    
    # Risk metrics
    annualized_volatility = calc_annualized_volatility(returns, periods = periods),
    sharpe_ratio = calc_sharpe(returns, rf_rate = rf_rate, periods = periods),
    sortino_ratio = calc_sortino(returns, rf_rate = rf_rate, periods = periods),
    calmar_ratio = calc_calmar(returns = returns, periods = periods),
    
    # Drawdown metrics
    max_drawdown = calc_max_drawdown(returns = returns),
    average_drawdown = calc_average_drawdown(returns = returns),
    recovery_time = calc_recovery_time(returns = returns),
    
    # Additional stats
    n_periods = length(returns),
    n_positive = sum(returns > 0, na.rm = TRUE),
    n_negative = sum(returns < 0, na.rm = TRUE),
    win_rate = sum(returns > 0, na.rm = TRUE) / length(returns),
    best_period = max(returns, na.rm = TRUE),
    worst_period = min(returns, na.rm = TRUE)
  )
  
  # Add benchmark comparison if provided
  if (!is.null(benchmark_returns)) {
    summary$information_ratio <- calc_information_ratio(returns, benchmark_returns, periods = periods)
    summary$benchmark_correlation <- stats::cor(returns, benchmark_returns, use = "complete.obs")
  }
  
  class(summary) <- c("performance_summary", "list")
  summary
}

#' Print Performance Summary
#'
#' @param x A performance_summary object
#' @param ... Additional arguments (not used)
#'
#' @export
print.performance_summary <- function(x, ...) {
  cat("\n")
  cat("==============================================\n")
  cat("         Performance Summary\n")
  cat("==============================================\n\n")
  
  cat("Return Metrics:\n")
  cat(sprintf("  Total Return:        %7.2f%%\n", x$total_return * 100))
  cat(sprintf("  CAGR:                %7.2f%%\n", x$cagr * 100))
  cat(sprintf("  Annualized Return:   %7.2f%%\n", x$annualized_return * 100))
  
  cat("\nRisk Metrics:\n")
  cat(sprintf("  Annualized Vol:      %7.2f%%\n", x$annualized_volatility * 100))
  cat(sprintf("  Sharpe Ratio:        %7.2f\n", x$sharpe_ratio))
  cat(sprintf("  Sortino Ratio:       %7.2f\n", x$sortino_ratio))
  cat(sprintf("  Calmar Ratio:        %7.2f\n", x$calmar_ratio))
  
  cat("\nDrawdown Metrics:\n")
  cat(sprintf("  Max Drawdown:        %7.2f%%\n", x$max_drawdown * 100))
  cat(sprintf("  Average Drawdown:    %7.2f%%\n", x$average_drawdown * 100))
  if (!is.na(x$recovery_time)) {
    cat(sprintf("  Recovery Time:       %7d periods\n", x$recovery_time))
  }
  
  cat("\nTrade Statistics:\n")
  cat(sprintf("  Total Periods:       %7d\n", x$n_periods))
  cat(sprintf("  Winning Periods:     %7d\n", x$n_positive))
  cat(sprintf("  Losing Periods:      %7d\n", x$n_negative))
  cat(sprintf("  Win Rate:            %7.2f%%\n", x$win_rate * 100))
  cat(sprintf("  Best Period:         %7.2f%%\n", x$best_period * 100))
  cat(sprintf("  Worst Period:        %7.2f%%\n", x$worst_period * 100))
  
  if (!is.null(x$information_ratio)) {
    cat("\nBenchmark Comparison:\n")
    cat(sprintf("  Information Ratio:   %7.2f\n", x$information_ratio))
    cat(sprintf("  Correlation:         %7.2f\n", x$benchmark_correlation))
  }
  
  cat("\n==============================================\n\n")
  invisible(x)
}
