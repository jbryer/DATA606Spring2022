#' Visualization designed to teach Loess regression.
#' 
#' This function is designed to display a scatterplot where the points are
#' shaded based upon their weight for estimating the Loess regression line
#' at a given x value.
#' 
#' @export
#' @import ggplot2
#' @import dplyr
#' @importFrom stats as.formula dist fitted median predict
#' @param formula formula used for the regression.
#' @param data the data.frame to run the regression.
#' @param center the point where the Loess regression is being estimated.
#' @param degree the degree of the polynomials to be used, normally 1 or 2.
#'        See [stats::loess()] for more information.
#' @param span the parameter α which controls the degree of smoothing.
#' @param draw_loess draw the Loess regression up to \code{x <= center}.
#' @param show_loess draw the full Loess regression line.
#' @param xlab label for the x-axis.
#' @param ylab lable for the y-axis.
#' @param ... currently unused.
#' @examples
#' data("faithful")
#' loess::loess_vis(formula = eruptions ~ waiting, data = faithful)
loess_vis <- function(formula,
					  data,
					  center = median(data[,all.vars(formula)[2],drop=TRUE]),
					  degree = 2,
					  span = 0.3,
					  draw_loess = FALSE,
					  show_loess = TRUE,
					  xlab = all.vars(formula)[2],
					  ylab = all.vars(formula)[1],
					  ...) {
	# See this page for why we need to set these variables to NULL. Hint:
	# it ensures these variables are bound to the function's environment.
	# https://nathaneastwood.github.io/2019/08/18/no-visible-binding-for-global-variable/
	
	x <- y <- weight <- NULL
	df <- data %>% dplyr::rename(y = all.vars(formula)[1],
								 x = all.vars(formula)[2])
	loess.out <- stats::loess(y ~ x,
							  data = df,
							  degree = degree,
							  span = span)
	df <- df %>% dplyr::mutate(fitted = fitted(loess.out))
	
	df.points <- df %>%
		dplyr::mutate(dist = abs(x - center)) %>%
		dplyr::filter(rank(dist) / n() <= span) %>%
		dplyr::mutate(weight = (1 - (dist / max(dist)) ^ 3) ^ 3)
	
	local_formula <- 'y ~ x'
	if(degree > 1) {
		for(i in 2:degree) {
			local_formula <- paste0(local_formula, ' + I(x^', i, ')')
		}
	}
	
	p <- ggplot2::ggplot(df.points, aes(x = x, y = y)) +
		ggplot2::geom_vline(xintercept = center, linetype = 2) +
		ggplot2::geom_point(data = df, alpha = 0.5, shape = 1) +
		ggplot2::geom_point(aes(color = weight)) +
		ggplot2::geom_smooth(method = 'lm',
					formula = as.formula(local_formula),
					aes(weight = weight),
					se = FALSE, color = '#43CD80', size = 0.5) +
		ggplot2::geom_point(x = center,
				   y = predict(loess.out, newdata = data.frame(x = center)),
				   color = 'orange', size = 4) +
		#            scale_color_gradient2(low = '#ece7f2', high = '#2b8cbe') +
		ggplot2::scale_color_gradient2(low = '#ece7f2', high = '#2E8B57') +
		ggplot2::ylim(c(min(df$y) - 0.05 * diff(range(df$y)),
			   max(df$y) + 0.05 * diff(range(df$y)))) +
		ggplot2::xlab(xlab) +
		ggplot2::ylab(ylab) +
		ggplot2::theme(text = element_text(size = 16))
	
	if(draw_loess) {
		p <- p + ggplot2::geom_line(data = df[df$x <= center,], aes(y = fitted),
						  color = 'orange', size = 1)
	}
	
	if(show_loess) {
		p <- p + ggplot2::geom_line(data = df, aes(y = fitted),
						   color = 'grey50', size = 0.5)
	}
	
	return(p)
}

