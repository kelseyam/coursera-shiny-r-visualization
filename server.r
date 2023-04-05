# Load libraries
library(shiny)
library(tidyverse)

# Read in data
adult <- read_csv("adult.csv")
# Convert column names to lowercase for convenience 
names(adult) <- tolower(names(adult))

# Define server logic
shinyServer(function(input, output) {
  
  df_country <- reactive({
    adult %>% filter(native_country == input$country)
  })
  
  # TASK 5: Create logic to plot histogram or boxplot
  output$p1 <- renderPlot({
    data <- read.csv("adult.csv")
    if (input$graph_type == "histogram") {
      # Histogram
      ggplot(df_country(), aes_string(x=input$radio_continuous)) +
        geom_histogram(bins = 30) +  # histogram geom
        labs(title = paste("Trend of",input$radio_continuous),
             y = "Number of People") +# labels
        facet_wrap(~prediction)    # facet by prediction
    }
    else {
      # Boxplot
      ggplot(df_country(), aes_string(y =input$radio_continuous)) +
        geom_boxplot() +  # boxplot geom
        coord_flip() +  # flip coordinates
        labs(title = paste("How", input$radio_continuous,"value is spread"),
             y = "Number of People",
             x = "Age") +  # labels
        facet_wrap(~prediction)    # facet by prediction
    }
    
  })
  
  # TASK 6: Create logic to plot faceted bar chart or stacked bar chart
  output$p2 <- renderPlot({
    # Bar chart
    p2 <- ggplot(df_country(), aes_string(x =input$radio_categorical)) +
      geom_bar(aes(color = 'categorical_variables')) +
      labs(title = paste("Trend of", input$radio_categorical),
           x = "Categorical Variable",
           y = 'Number of People')+# labels
      theme(axis.text.x.bottom = element_text(angle = 45),
            legend.position = "bottom") # modify theme to change text angle and legend position
    
    if (input$is_stacked) {
      p2 + geom_bar(aes(fill = prediction))
    }  # add bar geom and use prediction as fill
    
    else{
      p2 +geom_bar(aes(fill = input$radio_categorical)) +# add bar geom and use input$categorical_variables as fill 
        facet_wrap(~prediction)   # facet by prediction
    }
  })
  
})
