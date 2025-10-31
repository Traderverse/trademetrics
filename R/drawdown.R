#' Calculate Drawdown Metrics
#'
#' @description
#' Functions to calculate drawdowns and related metrics.
#'
#' @param equity_curve Numeric vector of equity values
#' @param returns Numeric vector of returns
#' @param ... Additional arguments
#'
#' @name drawdown-metrics
#' @keywords internal
NULL

#' Calculate Drawdown
#'
#' @description
#' Calculate the drawdown series from an equity curve or returns.
#'
#' @inheritParams drawdown-metrics
#'
#' @return Numeric vector of drawdown values (negative values)
#'
#' @examples
#' \dontrun{
#' equity <- c(100, 105, 110, 108, 115, 112, 120)
#' drawdowns <- calc_drawdown(equity_curve = equity)
#' }
#'
#' @export
calc_drawdown <- function(equity_curve = NULL, returns = NULL) {
  if (!is.null(returns)) {
    equity_curve <- cumprod(1 + returns)
  }
  
  if (is.null(equity_curve) || length(equity_curve) == 0) {
    return(numeric(0))
  }
  
  running_max <- cummax(equity_curve)
  drawdown <- (equity_curve - running_max) / running_max
  drawdown
}

#' Calculate Maximum Drawdown
#'
#' @description
#' Calculate the maximum drawdown (most negative point).
#'
#' @inheritParams drawdown-metrics
#'
#' @return Numeric value representing maximum drawdown (negative value)
#'
#' @examples
#' \dontrun{
#' equity <- c(100, 105, 110, 108, 115, 112, 120)
#' max_dd <- calc_max_drawdown(equity_curve = equity)
#' }
#'
#' @export
calc_max_drawdown <- function(equity_curve = NULL, returns = NULL) {
  dd <- calc_drawdown(equity_curve = equity_curve, returns = returns)
  if (length(dd) == 0) return(NA_real_)
  min(dd, na.rm = TRUE)
}

#' Calculate Drawdown Duration
#'
#' @description
#' Calculate the duration of each drawdown period.
#'
#' @inheritParams drawdown-metrics
#'
#' @return Data frame with drawdown periods and durations
#'
#' @examples
#' \dontrun{
#' equity <- c(100, 105, 110, 108, 115, 112, 120, 125)
#' dd_duration <- calc_drawdown_duration(equity_curve = equity)
#' }
#'
#' @export
calc_drawdown_duration <- function(equity_curve = NULL, returns = NULL) {
  dd <- calc_drawdown(equity_curve = equity_curve, returns = returns)
  
  if (length(dd) == 0) {
    return(data.frame(
      start = integer(0),
      end = integer(0),
      duration = integer(0),
      depth = numeric(0)
    ))
  }
  
  # Find drawdown periods
  in_drawdown <- dd < 0
  drawdown_starts <- which(diff(c(FALSE, in_drawdown)) == 1)
  drawdown_ends <- which(diff(c(in_drawdown, FALSE)) == -1)
  
  if (length(drawdown_starts) == 0) {
    return(data.frame(
      start = integer(0),
      end = integer(0),
      duration = integer(0),
      depth = numeric(0)
    ))
  }
  
  drawdown_periods <- data.frame(
    start = drawdown_starts,
    end = drawdown_ends,
    duration = drawdown_ends - drawdown_starts + 1,
    depth = sapply(seq_along(drawdown_starts), function(i) {
      min(dd[drawdown_starts[i]:drawdown_ends[i]], na.rm = TRUE)
    })
  )
  
  drawdown_periods
}

#' Calculate Average Drawdown
#'
#' @description
#' Calculate the average of all drawdowns.
#'
#' @inheritParams drawdown-metrics
#'
#' @return Numeric value representing average drawdown
#'
#' @examples
#' \dontrun{
#' equity <- c(100, 105, 110, 108, 115, 112, 120)
#' avg_dd <- calc_average_drawdown(equity_curve = equity)
#' }
#'
#' @export
calc_average_drawdown <- function(equity_curve = NULL, returns = NULL) {
  dd_duration <- calc_drawdown_duration(equity_curve = equity_curve, returns = returns)
  
  if (nrow(dd_duration) == 0) return(0)
  
  mean(dd_duration$depth, na.rm = TRUE)
}

#' Calculate Recovery Time
#'
#' @description
#' Calculate the time taken to recover from the maximum drawdown.
#'
#' @inheritParams drawdown-metrics
#'
#' @return Integer representing recovery time in periods
#'
#' @export
calc_recovery_time <- function(equity_curve = NULL, returns = NULL) {
  dd <- calc_drawdown(equity_curve = equity_curve, returns = returns)
  
  if (length(dd) == 0) return(NA_integer_)
  
  max_dd_idx <- which.min(dd)
  
  # Find when it recovers (drawdown becomes 0)
  recovery_idx <- which(dd[max_dd_idx:length(dd)] >= 0)
  
  if (length(recovery_idx) == 0) {
    # Still in drawdown
    return(NA_integer_)
  }
  
  recovery_time <- recovery_idx[1] - 1
  as.integer(recovery_time)
}
