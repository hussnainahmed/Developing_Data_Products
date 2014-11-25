library(shiny)
library(markdown)

palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
# source("energy_effeciency.R")
# building <- sqldf("select DISTINCT(building) from energy order by building ASC")
# Define server logic required to plot various variables against mpg
shinyServer(function(input, output, session) {
  
  # Combine the selected variables into a new data frame
  selectedData <- reactive({
    energy[,5:6]
  })
  
  clusters <- reactive({
     kmeans(selectedData(), input$clusters)
  })
  
 
  output$ui <- renderUI({
    
    # Depending on input$month_sel, we'll generate a different
    # UI component and send it to the client.
    if(input$month_sel == "yes")
    {
        sliderInput('month','Month of Year 2013', min= 1, max = 11 ,value =1)
    }     
           
  })
  
  
  buildingInput <- reactive(input$building)
  month_enable_Input <- reactive(input$month_sel)
  monthInput <- reactive(input$month)
  classes <- reactive({
    unique(clusters()$cluster)
  })
  
  #clus <-  reactive({cbind(energy[,4:6],clusters()$cluster)}) 
  
  output$plot1 <- renderPlot({ 
    
    if(buildingInput() == "All" && month_enable_Input() == "no")
    {
    par(mar = c(5.1, 4.1, 0, 1))
    plot(energy[,5:6],
         col = clusters()$cluster,
         pch = 1, cex = ceiling(energy[,4]/10000),
         lwd = 2,
         xlab="Average Hourly Electricity Efficiency (Watt.hr/sq.m)", ylab="Average Hourly Heating Efficiency (Watt.hr/sq.m)",
         cex.lab = 1.5,
         xlim=c(0, 50), ylim=c(0, 200))
        #identify(energy$elec_Wh_per_m2,energy$heat_Wh_per_m2 , labels=(energy$building))
        legend("topleft",legend=classes(),title="Clusters / Classess",col= unique(clusters()$cluster), pch = 1:1)
        legend("topright",legend= (unique(ceiling(energy[,4]/10000)) * 10000) ,title="Building Area (sq.meter)",col= "black", pch = 1:1, pt.cex = c(1,2,4), y.intersp=1.5, x.intersp=1.5)
     
        #points(clusters()$centers, pch = 4, cex = 2, lwd = 2)
    }
    
    else if(buildingInput() != "All" && month_enable_Input() == "no")
    {
      par(mar = c(5.1, 4.1, 0, 1))
      plot(energy[energy$building==buildingInput(),5:6],
           col = clusters()$cluster,
           pch = 1, cex = ceiling(energy[energy$building==buildingInput(),4]/10000),
           lwd = 2,
           xlab="Average Hourly Electricity Efficiency (Watt.hr/sq.m)", ylab="Average Hourly Heating Efficiency (Watt.hr/sq.m)",
           cex.lab = 1.5,
           xlim=c(0, 50), ylim=c(0, 200))
          legend("topleft",legend=classes(),title="Clusters / Classess",col= unique(clusters()$cluster), pch = 1:1)
          legend("topright",legend= (unique(ceiling(energy[,4]/10000)) * 10000) ,title="Building Area (sq.meter)",col= "black", pch = 1:1, pt.cex = c(1,2,4), y.intersp=1.5, x.intersp=1.5)
            
          #points(clusters()$centers, pch = 4, cex = 2, lwd = 2)
    }
    else if(buildingInput() != "All" && month_enable_Input() == "yes")
    {
      par(mar = c(5.1, 4.1, 0, 1))
      plot(energy[energy$building==buildingInput() & energy$month==monthInput(),5:6],
           col = clusters()$cluster,
           pch = 1, cex = ceiling(energy[energy$building==buildingInput() & energy$month==monthInput(),4]/10000),
           lwd = 2,
           xlab="Average Hourly Electricity Efficiency (Watt.hr/sq.m)", ylab="Average Hourly Heating Efficiency (Watt.hr/sq.m)",
           cex.lab = 1.5,
           xlim=c(0, 50), ylim=c(0, 200))
          legend("topleft",legend=classes(),title="Clusters / Classess",col= unique(clusters()$cluster), pch = 1:1)
          legend("topright",legend= (unique(ceiling(energy[,4]/10000)) * 10000) ,title="Building Area (sq.meter)",col= "black", pch = 1:1, pt.cex = c(1,2,4), y.intersp=1.5, x.intersp=1.5)
          
          
          #points(clusters()$centers, pch = 4, cex = 2, lwd = 2)
    }
    else if(buildingInput() == "All" && month_enable_Input() == "yes")
    {
      par(mar = c(5.1, 4.1, 0, 1))
      plot(energy[energy$month==monthInput(),5:6],
           col = clusters()$cluster,
           pch = 1, cex = ceiling(energy[energy$month==monthInput(),4]/10000),
           lwd = 2,
           xlab="Average Hourly Electricity Efficiency (Watt.hr/sq.m)", ylab="Average Hourly Heating Efficiency (Watt.hr/sq.m)",
           cex.lab = 1.5,
           xlim=c(0, 50), ylim=c(0, 200))
          legend("topleft",legend=classes(),title="Clusters / Classess",col= unique(clusters()$cluster), pch = 1:1)
          legend("topright",legend= (unique(ceiling(energy[,4]/10000)) * 10000) ,title="Building Area (sq.meter)",col= "black", pch = 1:1, pt.cex = c(1,2,4), y.intersp=1.5, x.intersp=1.5)
      
          #points(clusters()$centers, pch = 4, cex = 2, lwd = 2)
    }
    
        
    })
  
})