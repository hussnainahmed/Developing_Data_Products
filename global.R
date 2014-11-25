#############################################################################################
########  R - Script for performing Cluster Analysis on energy consumption data##############
#############################################################################################
########## Please refere to https://github.com/hazznain/BigData_for_Energy_Efficiency #######
########## if you are interested in pre-processing of large energy data sets to prepare######
########## input for this R script###########################################################
#############################################################################################



# function() for adding area information to energy consumption matrix and calculating energy effeciency
add_area <- function (address_file="data/hld_addresses_area.csv", data= energy_matrix){
  
  # reading the file with area information
  address <- read.csv(address_file,header=TRUE, sep=",")
  
  # filtering out buildings that have all information available and assigning column names to read data
  address <- address[complete.cases(address[,3]),]
  colnames(address) <-c("building","address","area")
  
  # Assigning the area information to all the buidlings in energy consumption matrix
  merged <- merge(data,address,all=FALSE)
  
  # Calculating the energy effeciencies for respective energy types
  merged$elec_Wh_per_m2 <- (merged$elec_consumption/merged$area)*1000
  merged$heat_Wh_per_m2 <- (merged$heat_consumption/merged$area)*1000
  
  # Selecting the required columns in required sequence
  energy_area_matrix <- merged[,c(1,5,2,6,7,8)]
  
  # Reterning the formulated matrix with energy effeciency
  energy_area_matrix
}

# For selection of the formulated energy consumption matrix file. 
# This file should be the output file of the energy_consumption_matrix.pig OR hld.sh scripts 
#library(ggplot2)
#set.seed(1234)


#reading the selected data and naming the columns
data <- read.table("data/energy_consumption_matrix.csv",header=FALSE,sep=",")
colnames(data) <- c("building","month","elec_consumption","heat_consumption")

# Selecting the data rows with consumption values greater than zero
energy_matrix <- data[data$elec_consumption > 0 & data$heat_consumption > 0,]

# calling the add_area() function to add area information and calculate energy effeciencies.

energy <- add_area()


# preparing the data for applying K-means algorithm for clustering
energy.features = energy
energy.features[1:4] <- list(NULL)

# Scaling the data to have common unit and variance 
# In this case the unit of both energy types are same. Scale() function is required to achieve unit variance 
matrix = scale(energy.features, center=TRUE, scale=TRUE)     

require(sqldf)
building <- sqldf("select DISTINCT(building) from energy")
building <- building$building
