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

#4) Lucky me, I live within the US

#5)
?read_csv
# From help file: "read_csv2() uses ; for separators, instead of ,. This is common in European countries which use , as the decimal separator."

#6) 
# From: https://www.terena.org/activities/multiling/ml-docs/iso-8859.html
#ISO-8859-1
#"Latin 1 covers most West European languages such as Albanian, Catalan, Danish, Dutch, English, Faeroese, Finnish, French, German, Galician, Irish, Icelandic, Italian, Norwegian, Portuguese, Spanish, and Swedish. The lack of the ligatures Dutch ij, French oe and ,,German`` quotation marks is tolerable."
#ISO-8859-2
#"Latin 2 is used for most Latin-written Slavic and Central European languages: Czech, German, Hungarian, Polish, Rumanian, Croatian, Slovak, Slovene."

#From: http://ergoemacs.org/emacs/unicode_basics.html
# GB 18030 (Used in China, contains all Unicode chars).
# EUC (Extended Unix Code). Used in Japan.
# IEC 8859 series (used for most European langs)

#But UTF-16 seems to cover everything

#7)

d1 <- parse_date("January 1, 2010", "%B %d, %Y")
d2 <- parse_date("2015-Mar-07", "%Y-%b-%d")
d3 <- parse_date("06-Jun-2017","%d-%b-%Y")
d4 <- parse_date(c("August 19 (2015)", "July 1 (2015)"),"%B %d (%Y)")
d5 <- parse_date("12/30/14","%m/%d/%y") # Dec 30, 2014
t1 <- parse_time("1705", "%H%M")
t2 <- parse_time("11:15:10.12 PM", "%I:%M:%OS %p")
