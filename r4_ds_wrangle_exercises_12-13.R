# Chapter 12-13 Problem Set

library(tidyverse)


# Chapter 12 --------------------------------------------------------------

#12.2.1

#1) 
#table 1- each column is a variable and each row is an observation (of the cases & population for each country each year)
#table 2 - each row is a single observation, but is either of population or cases (Defined by type) for a specific year
#table 3 - each row is an observation but the cases & population variables are combined into a single variable of 'rate'
#table 4 - data broken into 2 talbes, one table for population other for rates. Each row is the relevant variable value for all years for a country

#2)

t2pop <- table2 %>% filter(type == 'population')
names(t2pop)[names(t2pop) == 'count'] <- 'population'
t2tb <- table2 %>% filter(type == 'cases')
names(t2tb)[names(t2tb) == 'count'] <- 'cases'
table2sum <- merge(t2pop, t2tb, by = c( 'country', 'year'))
t2final <- table2sum %>% mutate(rate = (cases/population)*10000)
t2final
#Could have used spread() function and been much more efficient

table4rates <- table4a
names(table4rates)[names(table4rates) == '1999'] <- '1999 cases'
names(table4rates)[names(table4rates) == '2000'] <- '2000 cases'
table4rates$rate1999 <- (table4a$`1999`/table4b$`1999`)*10000
table4rates$rate2000 <- (table4a$`2000`/table4b$`2000`)*10000
table4rates

# Working with both was about the same - but the output of the data was different for each
# If I had to get everything in tidy data I think table2 would have been easier as it is closer to already being in tidy data form

#3)
table2 %>% spread(type, count)
?spread
ggplot(table2 %>% spread(type, count), aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))

#12.3.3

#1) 
stocks <- tibble(
year   = c(2015, 2015, 2016, 2016),
half  = c(   1,    2,     1,    2),
return = c(1.88, 0.59, 0.92, 0.17)
)
stocks %>% 
  spread(year, return) %>% 
  gather("year", "return", `2015`:`2016`)
stocks
# switches year and half columns when run
# has to do with ordering of columns when functions are run

?spread()
?gather()

# convert allows for variables of mixed type - avoids everything befoming factors

#2)
# Need `` around years:
table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")

#3)
people <- tribble(
  ~name,             ~key,    ~value,
  #-----------------|--------|------
  "Phillip Woods1",   "age",       45,
  "Phillip Woods2",   "height",   186,
  "Phillip Woods3",   "age",       50,
  "Jessica Cordero1", "age",       37,
  "Jessica Cordero2", "height",   156
)
spread(people, key, value)

# Names are repeated & thus not unique - we should have a personid to know the differences

#4)
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)
preg %>% 
  gather(male,female, key = "gender", value = "value") %>% 
  spread(pregnant, value)

# Need to gather & spread
# Variables are the count of people who are/aren't pregnant

#5)
table3 %>% 
  separate(rate, into = c("cases", "population"))

#12.4.3

#1) 
?separate()
# extra - what do do if character vector has too many pieces
# fill - what to do if character vector doesn't have enough pieces

#2)
?unite()
?separate()
# remove gets rid of original columns in df
# If we want to keep original columns set it to false
# Maybe we used extra/fill and want to confirm what original columns looked like

#3) 
?separate()
?extract()
# Extract requires that the groups we're extracting match a regex - more restrictive
# Conceptually there's a lof more ways to break up data than to just unite it

# 12.5.1

#1) 
# spread will adjust the actual column/row formatting of the data
# complete() will add rows that didn't exist before with values for specified columns and NA for others
# fill() will fill in blank NAs that already exist in the data with a new value (also sourced from existing data)

#2) 
?fill
# Source the value to fill in NAs from either above or below where the NAs actually are

#12.6.1
# 1)  NA means we don't have data for that set of people, but 0 means that 0 people were diagnosed
# From my knowledge of data, seems reasonable to do an NAOmit

#2) 
who %>%
gather(code, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>% 
#  mutate(code = stringr::str_replace(code, "newrel", "new_rel")) %>%
  separate(code, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1)
# Any row with new_rel gets a 'too few values' error since the next line of separate separates new_rel into New & Rel

#3)
who %>% group_by(country) %>% 
  summarise(iso2s = n_distinct(iso2)) %>% 
  filter(iso2s > 1)

who %>% group_by(country) %>% 
  summarise(iso3s = n_distinct(iso3)) %>% 
  filter(iso3s > 1)

# no country has any more than 1 distinct iso2 or iso3 so it's a 1 to 1 match

#4)
who %>%
  gather(code, value, new_sp_m014:newrel_f65, na.rm = TRUE) %>% 
  mutate(code = stringr::str_replace(code, "newrel", "new_rel")) %>%
  separate(code, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3) %>% 
  separate(sexage, c("sex", "age"), sep = 1) %>% 
  filter(year > 1994) %>% 
  group_by(country, year, sex) %>% 
  summarise(cases = sum(value)) %>% 
  ggplot(aes(x = year, y = cases, group = country, fill = country)) +
  geom_bar(stat = "identity", show.legend = FALSE, position = "dodge") +
  facet_grid(.~sex)

# too many countries for legend (too much data for great visualization)
  


# Chapter 13 --------------------------------------------------------------

library(tidyverse)
library(nycflights13)

#13.2.1 
#1) nycflights13 for dep/dest
#Then join to airports to get long/lat coords to draw lines on map

#2) airports joins to weather on faa = origin

#3) Could also have a link to dest as well as origin (even if called origin we could conceptually join to dest)

#4) Could have a 'specialDays' table 



#13.3.1
#1) 
flights %>% mutate(surkey = row_number())

#2) 
install.packages("Lahman")
library(Lahman)
install.packages("babynames")
library(babynames)
install.packages("nasaweather")
library(nasaweather)
install.packages("fueleconomy")
library(fueleconomy)
# Show primary key(s) combo in the count() function
Batting %>% count(playerID, yearID, stint) %>% filter(n > 1)
babynames::babynames %>% count(year, sex, name) %>% filter(nn > 1)
nasaweather::atmos %>% count(lat, long, year, month) %>% filter(n > 1)
fueleconomy::vehicles %>% count(id) %>% filter(n>1)
diamonds # No primary key, each diamond is its own observations

#13.4.6

#1)
install.packages("maps")
flightDelays <- flights %>% group_by(dest) %>% summarise(avgDelay = mean(dep_delay, na.rm = TRUE))


airports %>%
  left_join(flightDelays, c("faa" = "dest")) %>% 
  select(faa, lat, lon, avgDelay) %>% 
 filter(lon > -140 & !is.na(avgDelay))  %>%  #Ignore alaska & hawaii so graph looks better, make sure avgDelay exists
ggplot( aes(lon, lat, size = avgDelay, color = avgDelay)) +
  borders("state") +
  geom_point() +
  coord_quickmap()
#2) 
flights %>% 
  left_join(airports, c('dest' = 'faa')) %>% 
  left_join(airports, c('origin' = 'faa'))

#3)
?planes
flights %>% 
  left_join(planes, by = 'tailnum') %>% 
  mutate(planeAge = 2017-year.y) %>% 
  group_by(planeAge) %>% 
  summarise(avgDelay = mean(dep_delay, na.rm = TRUE), totalFlights = n()) %>% 
  filter(totalFlights > 100) %>% 
  ggplot(aes(x = planeAge, y = avgDelay)) + 
  geom_point() +
  geom_smooth()

  

# not too much of a corrolation
# In first 10 years seems to be as plane gets older delays get longer
# but next 10 years it drops back down
# then data is sporadic after that

flights %>% 
  left_join(planes, by = 'tailnum') %>% 
  mutate(planeAge = 2017-year.y) %>% 
  filter(planeAge > 60) %>% 
  select(tailnum, planeAge, origin, dest)
# This plane is 61 years old and made 22 flights from JFK to SFO..... WTF

#4) 

fsum <- flights %>% 
  left_join(weather, c('origin', 'year', 'month', 'day', 'hour')) %>% 
  group_by(origin, year, month, day, hour, temp, dewp, humid, wind_dir, wind_speed, wind_gust, precip, pressure, visib) %>% 
  summarise(avgDelay = mean(dep_delay, na.rm = TRUE)) %>% 
  
  #Next lines are shit code but not sure how to do it using ggplot
  group_by(visib) %>% summarise(avgDelay2 = mean(avgDelay, na.rm = TRUE))
  
# How do I bin x values while calculating function on y values
# Could cut the df but should be a nice way to do it in ggplot with bins
ggplot(fsum, aes(x = visib, y = avgDelay2)) +
  geom_point()
    
# change the x axis variable to see where strongest corrolation is    
# temp - minimal correlation as it gets hotter more delays    
# dewp - no correlation
# humid - no correlation
# wind_dir - values between 50 & 200 have higher delays (makes a sort of sinusodial function)
# wind_speed - higher wind speed more delay
# wind_gust - higher --> more delay
# precip - no correlation
# pressure - small correlation of lower pressure more delay
# visib - lower visib more delay

#5) 
weather %>% 
  filter(month == 6 & day == 13) %>% 
  left_join(flights, c('origin', 'year', 'month', 'day', 'hour')) %>% 
  group_by(hour, origin) %>% 
  summarise(avgDelay = mean(dep_delay, na.rm = TRUE)) %>% 
  ggplot(aes(x = hour, y = avgDelay, group = origin, color = origin)) +
  geom_line()

#super bad average delays for all airports
# From 'Derecho' series on the 12th/13th (huge amounts of tornados/storms across midwest & southeast)

#13.5.1
#1)
flights %>% 
  filter(is.na(tailnum))
# All missing tailnum flights don't have a dep_time (they never took off)
tmpflights <- flights %>% 
  select(tailnumf = tailnum) 

flights %>% 
  anti_join(planes, c('tailnum' = 'tailnum')) %>% 
  count(carrier, sort = TRUE) %>% 
  View
flights
# Almost all flights are MQ or AA carriers

#2)

flights %>% 
  inner_join(flights %>% 
  count(tailnum) %>% 
  filter(n > 100), 'tailnum')

#3)
fueleconomy::common
fueleconomy::vehicles

?common
#Don't know which year the models dataset came out so don't have reference for 'years' meaning column
# So code will have cars 'n' value repeat across years

vehicles %>% 
  inner_join(common, by = c('make', 'model')) %>% 
  arrange(desc(n)) %>% 
  View

#4) 
flights %>% 
  group_by(year, month, day) %>% 
  summarise(avgDelay = mean(dep_delay, na.rm = TRUE)) %>% 
  ungroup() %>% 
  mutate(primaryKey = row_number()) %>% 
  mutate(TwoDayLagVal = (lead(avgDelay) + avgDelay)/2) %>% 
  arrange(desc(TwoDayLagVal))
  
# How to do a lag over 47 previous values without hardcoding it?
# Words 2 day set was March 7&8 with an average delay of 51 min over the 2 days

#5)
anti_join(flights, airports, by = c("dest" = "faa"))
# drops all observations in flights that have a match in airports
# Shows all flights that went to an airport not in the airports table

anti_join(airports, flights, by = c("faa" = "dest"))
# Shows all airports in the airports table that never had a flight in the flights table go to them

#6)
flights %>% 
  group_by(tailnum) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  filter( carriers > 1)
# Actually a few planes with multiple carriers
# tailnums in in PQ and AT

