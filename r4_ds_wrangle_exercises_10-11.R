### Data Science Accelerator Problem Set Ch. 9-16
# Otis Skipper

library(tidyverse)
library(nycflights13)
# 10.5 --------------------------------------------------------------------

#1) use the class function
class(mtcars)
class(as_tibble(mtcars))

#2)
df <- data.frame(abc = 1, xyz = "a")
df$x #even though x is not a defined column this still returns the value of 'a'
df[, "xyz"] # Has turned 'a' into a factor with levels 'a'
df[, c("abc", "xyz")] # returns 2 columns as expected

tf <- tibble(abc = 1, xyz = "a")
tf$x #returns error since column doesn't exist
tf[, "xyz"] #retains character value of a instead of focrcing factor
tf[, c("abc", "xyz")] #returns 2 columns as expected but also gives data type which is nice bonus

#tibbles return the data type (nice feature) and also don't allow printing non-existent columns, also keep original data type (don't force factor)

#3) 
var <- "mpg"
cartbl <- as_tibble(mtcars)
cartbl[var]

#4) 
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
#a) 
annoying['1']
#b)
ggplot(annoying, aes(x = `1`, y = `2`)) +
  geom_point()
#c)
annoying$`3` <- annoying$`2`/annoying$`1`
#d)
colnames(annoying) <- c('one', 'two', 'three')

#5) 
?tibble::enframe()
# converts vertor or list to a 2 column data frame
# Sometimes data we get is in vector form but we need to add to data frame for manipulation/context

#6) 

options(tibble.max_extra_cols = 5)
flights




# Chapter 11 --------------------------------------------------------------

#11.2.2 

#1)    
# use read_delim
?read_delim
read_delim("a|b|c\n4|5|6", '|', col_names = c("x", "y", "z"))

#2) Other things in common
?read_csv
#col_names, col_types, locale, , na, whoted_na, trim_ws, n_max, guess_max, progress

#3)
?read_fwf()
# file and col_positions have to be defined, all other variables have set default values when function is called

#4)
read_delim("x,y\n1,'a,b'", ",", quote = "'")

#5)
read_csv("a,b\n1,2,3\n4,5,6") # First row is only 2 columns, so whole set gets limited to 2 columns - don't see 3 or 6 
read_csv("a,b,c\n1,2\n1,2,3,4") # Second row is only 2 columns, even though read was initialized first row with 3. Get NA value in column 3 of row 2
read_csv("a,b\n\"1") # Second row is missing value for second column - get NA
read_csv("a,b\n1,2\na,b")
read_csv("a;b\n1;3") # using read_csv but the files are distinguished by semicolns - should have used read_delim

#11.3.5

#1)
?locale
#Date_names, date_format, decimal_mark, grouping_mark, tz, encoding, time_format
# All are important but I ordered them (From my understanding)

#2)
parse_number("123.456", locale = locale(decimal_mark = ".", grouping_mark = "."))
# Throws Error: `decimal_mark` and `grouping_mark` must be different
parse_number("123.456", locale = locale(decimal_mark = ","))
# grouping mark defaults to `.` when decimal_mark is set to `,`
parse_number("123,456", locale = locale(grouping_mark =  "."))
# Decimal mark defaults to `,` when grouping_mark is set to `.`

#3) 
# date_format & time_format set the kind of formatting for the date and time
parse_date('1/15/2001',locale = locale(date_format='%m/%d/%Y'))
?  parse_date('1/15/2001 01:23',locale = locale(date_format='%m/%d/%Y', time_format = '%H:%M'))
parse_date('01:23',locale = locale(time_format='%H%M'))
