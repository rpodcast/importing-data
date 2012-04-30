#----------------------------------------------------------------------------------------------
# File: importing-data-basics.R
# Date: 04-28-2012
# Author: Eric Nantz
# URL: https://github.com/thercast/importing-data/blob/master/importing-data-basics.R
# Email: theRcast@gmail.com
# Purpose: Demonstrate how to import data files: 
#          - Delimited text file
#          - HTML tables
#          - MySQL database
# www.r-podcast.org/the-r-podcast-episode-6-importing-data-from-external-files
# License: Creative Commons Attribution-ShareAlike 3.0 Unported License
#----------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# importing space-delimited text SAT and GPA data file from the internet
# web url: http://www.stats4stem.org/sat-and-college-gpa.html
# data url: http://www.stats4stem.org/uploads/1/7/6/7/1767713/sat.txt
# data is in txt format and space-delimited, with a header
#-----------------------------------------------------------------------------

data.url <- "http://www.stats4stem.org/uploads/1/7/6/7/1767713/sat.txt"

# import the data
sat <- read.table(file=data.url, header=TRUE)

#------------------------------------------------------------------------------------
# Importing MySQL database using RMySQL package
#
# My server has a MySQL database created by MythTV (www.mythtv.org)
#
# see http://playingwithr.blogspot.com/2011/05/accessing-mysql-through-r.html 
# for a nice tutorial on using RMySQL package
#-----------------------------------------------------------------------------------

library(RMySQL)

username <- "mythtv"
userpass <- "some-password"
databasename <- "mythconverg"
host <- "localhost"

mydb = dbConnect(MySQL(), user=username, password=userpass, dbname=databasename, host=host)

dbListTables(mydb)

# query to select all columns from table called recorded
rs <- dbSendQuery(mydb, "select * from recorded")

# save the first 20 records into a data frame
rs.data <- fetch(rs, n=20)

# clear the query
dbClearResult(rs)

# disconnect from the database
dbDisconnect(mydb)


#---------------------------------------------------------------------------------------
# Importing data contained in an HTML table: NHL playoff team statistics from ESPN.com
# web url: http://espn.go.com/nhl/statistics/team/_/stat/scoring/year/2012/seasontype/3
# - only 1 table present on the page, with a header
#---------------------------------------------------------------------------------------

library(XML)

table.url <- "http://espn.go.com/nhl/statistics/team/_/stat/scoring/year/2012/seasontype/3"
rawlist <- readHTMLTable(table.url, header=TRUE)
rawtable <- rawlist[[1]]

# row 12 has the column header repeated, so I need to re-run import skipping that row

rawlist <- readHTMLTable(table.url, header=TRUE, skip.rows=12)
rawtable <- rawlist[[1]]

# check column formats, we see that they have all been convereted to factors
str(rawtable)

# try the import again by specifying column classes

num.columns <- ncol(rawtable)
class.vec <- c("integer", "factor", rep("numeric", num.columns-2))

rawlist <- readHTMLTable(table.url, header=TRUE, skip.rows=12, colClasses=class.vec)
rawtable <- rawlist[[1]]
str(rawtable)

# now the data is ready for analysis: for now run a quick summary
summary(rawtable)
