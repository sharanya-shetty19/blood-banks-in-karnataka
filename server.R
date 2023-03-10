library(shiny)
library(plotly)
library(dplyr)

library(leaflet)
library(ggplot2)

bb_data <- read.csv("bb-data.csv", stringsAsFactors = FALSE )
bb_data <- data.frame(bb_data)
bb_data$Latitude <-  as.numeric(bb_data$Latitude)

library(DT)

shinyServer(function(input, output) {
  # Import Data and clean it
  bb_data$Longitude <-  as.numeric(bb_data$Longitude)
  bb_data=filter(bb_data, Latitude != "NA") # removing NA values
  
  # new column for the popup label
  
  bb_data <- mutate(bb_data, cntnt=paste0('<strong>Name: </strong>',Blood.Bank.Name,
                                          '<br><strong>State:</strong> ', State,
                                          '<br><strong>Time:</strong> ', Service.Time,
                                          '<br><strong>Mobile:</strong> ',Mobile,
                                          '<br><strong>HelpLine:</strong> ',Helpline,
                                          '<br><strong>Contact1:</strong> ',Contact.No.1,
                                          '<br><strong>Contact2:</strong> ',Contact.No.2,
                                          '<br><strong>Contact3:</strong> ',Contact.No.3,
                                          '<br><strong>Email:</strong> ',Email,
                                          '<br><strong>Website:</strong> ',Website)) 
  
  # create a color paletter for category type in the data file
  
  pal <- colorFactor(pal = c("#1b9e77", "#d95f02", "#7570b3"), domain = c("Charity", "Government", "Private"))
  
  # create the leaflet map  
  output$bbmap <- renderLeaflet({
    leaflet(bb_data) %>% 
      addCircles(lng = ~Longitude, lat = ~Latitude) %>% 
      addTiles() %>%
      addCircleMarkers(data = bb_data, lat =  ~Latitude, lng =~Longitude, 
                       radius = 3, popup = ~as.character(cntnt), 
                       color = ~pal(Category),
                       stroke = FALSE, fillOpacity = 0.8)%>%
      addLegend(pal=pal, values=bb_data$Category,opacity=1, na.label = "Not Available")%>%
      addEasyButton(easyButton(
        icon="fa-crosshairs", title="ME",
        onClick=JS("function(btn, map){ map.locate({setView: true}); }")))
  })
  #creating graph
  
  
  output$brandBar <- renderPlot({
   
    color <- c("#1b9e77", "#d95f02", "#7570b3")
    y = c(27, 41, 131)
    barplot(y,ylab="total",xlab="hospitals",names.arg = c("Charity", "Government", "Private"),col = color)

  })
  
  #create a data object to display data
  
  output$data <-DT::renderDataTable(datatable(
    bb_data[,c(-1,-23,-24,-25,-28:-35)],filter = 'top',
    colnames = c("Blood Bank Name", "State", "District", "City", "Address", "Pincode","Contact No.",
                 "Mobile","HelpLine","Fax","Email", "Website","Nodal Officer", "Contact of Nodal Officer",
                 "Mobile of Nodal Officer", "Email of Nodal Officer","Qualification", "Category", "Blood Component Available",
                 "Apheresis", "Service Time", "Lat", "Long.")
  ))
  
  
})

