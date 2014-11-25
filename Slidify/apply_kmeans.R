#############################################################################################
########  R - Script for performing Cluster Analysis on energy consumption data##############
#############################################################################################
########## Please refere to https://github.com/hazznain/BigData_for_Energy_Efficiency #######
########## if you are interested in pre-processing of large energy data sets to prepare######
########## input for this R script###########################################################
#############################################################################################

library(googleVis)

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
input = scale(energy.features, center=TRUE, scale=TRUE)

# Scaling the data to have common unit and variance 
# In this case the unit of both energy types are same. Scale() function is required to achieve unit variance 
matrix = scale(energy.features, center=TRUE, scale=TRUE)     

# Applying K-means to cluster data into 4 classes
# Number of classes were pre-defined for our use case, So application of K-means was a good enough choice
results = kmeans(input,4)


# Adding the calculated clustering information back to energy effeciency matrix for visualization purpose 
building <- c(energy$building)
month <- c(energy$month)
area <- c(round(as.numeric(energy$area),1))
elec_Wh_per_m2 <- c(as.integer(round(as.numeric(energy$elec_Wh_per_m2),0)))
heat_Wh_per_m2 <- c(as.integer(round(as.numeric(energy$heat_Wh_per_m2),0)))
cluster <- c(results$cluster)
main_matrix_k4 <- data.frame(building,month,area,elec_Wh_per_m2,heat_Wh_per_m2,cluster)

g <- ggplot(main_matrix_k4, aes(elec_Wh_per_m2,heat_Wh_per_m2))
h <- g + geom_point(aes(color=factor(cluster),size= area), shape=21)
i <- h + scale_size_continuous(range = c(2,8))
j <- i + scale_color_brewer(palette="Set1")
p <- j + labs(title="Classification of buildings on the basis of energy effeciency") + labs(x="Electrcity Consumption(wh) per m2 ", y ="Electrcity Consumption for Heating (wh) per m2 ")
print(p)
dev.copy(png, file="assets//fig/unnamed-chunk-1-1.png", height=600, width=800)
dev.off()
