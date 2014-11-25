## Using Classification for Energy Effeciency

### Project Background
The data visualization in this shiny application is part of another project [Using Big Data Analytics for energy effeciency](https://github.com/hazznain/BigData_for_Energy_Efficiency). The details of the project can also be found on this [website](http://catalyc.net/). We are only utilizing the preprocessed data from this project.

<font color='red'> The interactive visulaization itself can be run and understood independently.</font>  

### Highlights of the Plot
The interactive graph in this application provides following insights.

1. Group the building with similar electricty and electricity used for heating usage effeciency patterns into configuerable number of clusters using [K-means](http://en.wikipedia.org/wiki/K-means_clustering) algorithm.
2. See how the energy effeciency patterns change for different months within one year (2013 - Data available for first 11 months).
3. See how the behaviour of each building changes with seasons.


### How to use the interactivity

The graph has three main elements for interactivity.

1. An edit Box to enter "Number of Cluster". It can be used to define number of energy efficiency groups for the buildings.

2. A drop down list to select a particular building.

3. Radio button control to either analyze the plot for all the months or select month one by one. If you select "For Month" then it should enable a fluid slider input for slection of the respective month.

### Typical use cases.

1. By default case: Any number of cluster e.g. 4 (by default) and All Buildings(by ) and All months will give 4 classes in a scatter plot. Each point will represent combined energy efficiency (electricity + heating) of a building in a particular month. Color of the point represents the respective class while size of the point shows the size of the building. The default setting provides an overview with an insight that size of building does not necessarily dictates the energy effeciency of a building.

2. Any number of cluster with All the months and select building one by one. This will show the shifting behaviour of a particular building throughout various months.

3. Any number of clusters and All buildings while selecting month one by one. This will reveal the collective monthly energy effeciency behaviour.

### Elements of emphasize

* Color of the points represents the class / cluster / group.
* Size of the point represents the size categories. Rounded of to the nearest categories.




