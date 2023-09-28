#-------------------------------------------------------------------------------
# PMIM 102  Assignment
# Dobgima Mofor
# November 2021
# Compiled in R version 4.1.2 -- 'Bird Hippie'
# 
# The files to be included in this project are Benziodiazepines.R,Count practices.R,
# County recode.R, Hypertension.R, Insulin.R, Main file.R, Select County.R, Select Practice.R
#-------------------------------------------------------------------------------
# Identifiers
# Normal/Capscase: Constants
# Snake_case: Variabes
# Dott.ed: Functions
#-------------------------------------------------------------------------------
# Begin here!!!

# The program would use the following packages

library(tidyverse)                          # Loads essential packages for data manipulation
library(RPostgreSQL)                        # Loads package for connecting to the SQL database
library(crayon)                             # Colours console text.

# The following colors would be used to highlight information
note <- yellow$bold                         # Highlights important output
warn <- black$bgWhite$bold                  # Indicates next line of code would run for a while
est <- red$bgWhite$bold                     # Estimates the time for the next line to run
heading <- black$bold$underline             # Indicates a heading

#-------------------------------------------------------------------------------
# Load the driver to access the PostgreSQL server.
drv <- dbDriver("PostgreSQL");

# Create a connection to the GP practice database on the server
con <- dbConnect(drv, dbname = "gp_practice_data", 
                 host = "localhost", port = 5432,
                 user = "postgres", password=.rs.askForPassword('Please enter database password:'))

#Check the tables in the database. This also ensures that the connection works

cat(note('This program would use data from the following tables:\n'))
dbListTables(con)

#-------------------------------------------------------------------------------
cat(heading('\014\nDobgima\'s code - Part 1: 
Extract health information from the Wales GP Prescribing Data Extract.\n'))

# Run the following lines of code to regroup the data
source('County recode.R')             # Limitation: Practices that do not have
                                      # area, county or posttown info are excluded

cat(warn('\014\nAggregating practices by county. Please wait...'),est('(30s)'))
source('count practices.R')

# View created table
Wales

#-------------------------------------------------------------------------------
cat('\014\n---------------------------',
    '----------------------------\n', 
    sep='Let\'s begin the data processing!')

# Select a County
source('Select County.R')

# Select a practice from the chosen county
source('Select Practice.R')

# View the Hypertension rate from the selected
# county, with the Wales average as reference

source('Hypertension.R')
Hyp_plot

#-------------------------------------------------------------------------------

# Analysis comparing the rate of hypertension and the rate of insulin 
# prescribing at a practice level

cat(warn('\014\nAggregating practices by county. Please wait...'),est('(7s)'))
source('Insulin.R')

# Perform a two-sample t-test to evaluate the hypothesis

cat('\014\n-------------------------',
    '-----------------------------\n', 
    sep=heading('Test for Statistical significance'))

# Test the Central Limit Theorem
Check.CLT()

# View plot of test_data variables
#head(test_data)            #Uncomment to view data
with(test_data, boxplot(hyp_rate, col='tan3', main='Boxplot of Hypertension rate'))
with(test_data, boxplot(Ins_rate, col='yellow4', main='Boxplot of Insulin prescription rate'))

#with(test_data, plot(hyp_rate,Ins_rate))              #Uncomment to check for relationship

# Perform test and view results
test.x()

#-------------------------------------------------------------------------------
#----------------------------------- Part 2 ------------------------------------

cat(heading('\014\nDobgima\'s code - Part 2:
Explore Hypertension data further and then explore Benziodiazepines.\n'))

# Check data for counties with hypertension rates above the practice average
Hyp_plot2
cat(note('The Hypertension rate is expectedly proportionate to populaton size,
with the more populated counties of Clwyd, Gwent and Mid Glamorgan',
    'standing out.', sep = ' '))

#-------------------------------------------------------------------------------
# This part examines Benzodiazepine prescriptions in Wales

cat(warn('Loading Benzodiazepine data from database. Please wait...'), est('(5s)'))
source('Benzodiazepines.R')

# The following table creates categories for number of Benzodiazepine prescriptions
view(bz)

#Check for association between the drug prescriptions and year
check.bzyr()

#Visualize the data
Bnz_plotyr

# Aggregate Benzodiazepine data by county
bz1

# Check for association between Benzodiazepine prescription and County
check.bzcty()

#Visualize the data
Bnz_plotCty

#-------------------------------------------------------------------------------
# Close the connection and unload the drivers.
dbDisconnect(con)
dbUnloadDriver(drv)

cat(black$bold('\nEnd of analysis!
\nThank you for using Dob\'s code.
For support, please contact Dobgima on dndanji13@gmail.com'))

