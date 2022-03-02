#' The Shiny App UI.
#' 
#' The user interface for the Loess shiny app.
#' 
#' @import shiny
#' @importFrom shinyWidgets chooseSliderSkin
#' @importFrom shinyBS bsPopover
#' @export
shiny_ui <- function() {
	navbarPage(
		id = 'navbarpage',
		title = "Loess Smoothing",
		#theme = 'readable',
		#theme = shinythemes::shinytheme("simplex"),
		# shinythemes::themeSelector(),
		
		tabPanel(
			'Plot',
			shinyWidgets::chooseSliderSkin("Shiny", color="seagreen"),
			sidebarLayout(
				sidebarPanel(
					selectInput('dataset',
								'Dataset:',
								choices = c('Quadratic plus random noise' = 'quadratic',
											'Cubic plus random noise' = 'cubic',
											'Old Faithful' = 'faithful')),
					uiOutput('center_input'),
					selectInput('degree',
								'Degree:',
								choices = c('Linear' = 1,
											'Quadratic' = 2)),
					numericInput('span',
								 'Span:',
								 min = span_range[1],
								 max = span_range[2],
								 step = .05,
								 value = .3),
					checkboxInput('draw_loess', label = 'Draw Loess fit (best used with animation on the slider)', value = FALSE),
					checkboxInput('show_loess', label = 'Show Full Loess fit', value = FALSE),
					helpText(" "),
					helpText("Click your mouse on the plot to see an explanation of the graph.  (Remove with another click)"),
				),
				
				mainPanel(
					plotOutput("loess_plot"),
					shinyBS::bsPopover(id="loess_plot",
							  title="Description",
							  placement="left",
							  trigger="click",
							  content = paste0("This app is a visual/conceptual demonstration of the elements of a  Loess Plot.",
							  				 "The orange point plots the predicted value from an X axis value midway along a local regression ",
							  				 "shown by the local (green) regression fit.  The center of this locally weighted regression and its X axis span ",
							  				 "can be controlled by the CENTER slider and SPAN numeric entry box.",
							  				 "<br><br>",
							  				 "Best use of the app would use the animation control for the CENTER slider ",
							  				 "and the checkbox for actively drawing the Loess fit.",
							  				 "<br><br>",
							  				 "The full loess fit can also be displayed with the second checkbox.",
							  				 "<br><br>",
							  				 "The local regression can be specifed as a linear or quadratic fit with the DEGREE dropdown. ",
							  				 "<br><br>",
							  				 "Also see the ABOUT tab."))
				)
			)
		)
		
		# tabPanel(
		# 	'About',
		# 	# withMathJax(includeHTML(paste0(find.package('loess'), '/doc/loess.html')))
		# 	htmlOutput('about')
		# )
	)
}

#' The Shiny App Server.
#' 
#' The server code for the Loess shiny app.
#' 
#' @param input input set by Shiny.
#' @param output output set by Shiny.
#' @param session session set by Shiny.
#' @import shiny
#' @importFrom stats rnorm
#' @export
shiny_server <- function(input, output, session) {
	# Returns the data.frame. The first column will be plotted on the x-axis,
	# second on the y-axis
	getData <- reactive({
		req(input$dataset)
		df <- NULL
		if(input$dataset == 'cubic') {
			df <- tibble(
				x = seq(-1, 1, by = 0.01),
				y = x^3 + rnorm(length(x), mean = 0, sd = 0.05) - x
			)
		} else if(input$dataset == 'quadratic') {
			df <- tibble(
				x = seq(-1, 1, by = 0.01),
				y = -x^2 + rnorm(length(x), mean = 0, sd = 0.1) - x
			)
		} else if(input$dataset == 'faithful') {
			df <- data.frame(
				x = faithful$waiting,
				y = faithful$eruptions
			)
			names(df) <- c('Inter-eruption interval',
						   'Eruption length')
		} else {
			stop('No dataset specified.')
		}
		return(df)
	})
	
	# output$about <- VisualStats::renderRmd(
	# 	paste0(find.package('loess'), '/doc/loess.Rmd'),
	# 	input,
	# 	envir=environment())
	
	output$center_input <- renderUI({
		df <- getData()
		fluidPage(sliderInput("center",
							  "Center:",
							  min = min(df[,1]),
							  max = max(df[,1]),
							  value = (min(df[,1])),
							  # value = min(df[,1]) + (diff(range(df[,1])) / 4),
							  step = diff(range(df[,1])) / 20,
							  round = TRUE,
							  animate = animationOptions(interval = 800, loop = TRUE))
		)
	})
	
	validateInput <- reactive({
		validate(
			need(input$span >= span_range[1] & input$span <= span_range[2],
				 paste0(' Please select a span between ', span_range[1], ' and ', span_range[2], '.'))
		)
	})
	
	output$loess_plot <- renderPlot({
		validateInput()
		req(input$degree)
		req(input$span)
		req(input$center)
		
		df <- getData()
		df$x <- df[,1,drop=TRUE]
		df$y <- df[,2,drop=TRUE]
		
		loess_vis(formula = y ~ x,
				  data = df,
				  degree = input$degree,
				  draw_loess = input$draw_loess,
				  show_loess = input$show_loess,
				  center = input$center)
	})
}

#' Run the Loess shiny app.
#' 
#' This will start the shiny app to demonstrate the loess_vis function.
#' 
#' @param span_range the range of values the user is allowed to set the span.
#' @param ... not currently used.
#' @import shiny
#' @export
loess_shiny <- function(span_range = c(0.05, 1), ...) {
	shiny_env <- new.env()
	if(!missing(span_range)) {
		print('Setting parameters')
		assign('span_range', span_range, shiny_env)
	}
	environment(shiny_ui) <- shiny_env
	environment(shiny_server) <- shiny_env
	app <- shiny::shinyApp(
		ui = shiny_ui,
		server = shiny_server
	)
	return(app)
}
