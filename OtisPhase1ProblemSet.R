# PHASE 1 DS ACCELERATOR PROBLEM SET
# OTIS SKIPPER

# install.packages("tidyverse")
# install.packages("nycflights13)
library(tidyverse)


# Ch. 3 Problems ----------------------------------------------------------

### Problem 3.2.4
#1
ggplot(data = mpg) #Produces blank plot
#2
nrow(mpg) #234 Rows
ncol(mpg) #11 Columns
#3 
?mpg #drv: f = front-wheel drive, r = rear wheel drive, 4 = 4wd
#4
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = hwy, y = cyl))
#5 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = class, y = drv))
# class and drive are both discrete factors
# A scatterplot of this will overlay multiple observations on top of each other
# We have 234 observations in our set but only see 12 points in the scatter plot


### Problem 3.3.1

#1 The color is being defined in the ase(), needs to be defined outside

#2
?mpg
for(i in 1:ncol(mpg)){print(class(mpg[[i]]))}
#categorical - manufacturer, model, displ, trans, fl, class
#continuous - displ, year, cyl, cty, hwy
#Running mpg shows the <chr>, <dbl> definitions for each column - (also in code above)

#3
#Map color/size to cty/hwy (continuous)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y =model, color = cty, size = hwy))

#Throws error when trying to map size to continuous variable
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y =model, shape = cty))
#Map Size/Color do discrete variables - able to do
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y =model, color = manufacturer, size = class))

# Color - Discrete (different colors), continuous (gradient of same color)
# Size - Discrete (different sizes, but may not make sense), continuous (scaled in size)
# Shape - Discrete (different shapes), continuous (unable to do this, throws error)

#4
#Able to map same variable to multiple aes, but redundant
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y =model, color = cty, size = cty))

#5 
#Stroke increases width of line
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y =model, shape = fl, stroke = cty*0.05))

#6 
#creates 2 disparate colors based on T/F value
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y =model, color = displ < 5))

### Problem 3.5.1
# 1 - creates many different faces but function still runs
# With a larger sample set of a continuous variable the graph would become unable to interpret due to too many facets
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ cty, nrow = 2)

# 2 
# The empty facets mean that there is no point in the data that matches both drv & cyl (ie: no car is 5 cyl & r drv)
# These empty facets line up with the overlaps of drv & cyl in the example plot where there are no scatter points

# 3
# disp vs hwy, brokedn out by 3 rows of the drv variable
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

# disp vs hwy broken into 4 columns of the cyl variable
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

# Using the . allows to grid facets but only off of 1 variable for a column/row instead of needing 2 variables to define the grid

# 4
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
# With facets it is easy to see trends in each individual set of data broken out by class
# But facets make it harder to visually compare between any 2 classes - this is where colors would be useful
# As the data set grows trying to compare different colors of classes on the same graph could become more cumbersome so facets can easily deliniate the data

# 5 
# nrow returns number of rows, ncol returns number of columns
# Can also use as.table, switch, dir to affect the layout of the panes
#facet_grid() will already have a pre-determined number of rows/columns based on the number of observations of each variable defining the grid

# 6
# Will produce a representation that is more columns than rows - people like widescreen?

### Problem 3.6.1

#1 - geom_line, geom_boxplot, geom_histogram, geom_area

#2 N/A

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE, show.legend = FALSE)

#3 Removes legend from graph, default is to show legend. Used earlier to introduce concept

#4 se = FALSE gets rid of the confidence interval

#5 Plots will look the same - aes is just more generically defined for all of plot in first one

#6 

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth( se = FALSE)


ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth( se = FALSE, aes(group = drv))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth( se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth( se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth( se = FALSE, aes(linetype = drv))

ggplot(data = mpg) +
  geom_point(aes(x = displ, y = hwy, fill = drv), size = 5,  color = "white") +
  geom_point(aes(x = displ, y = hwy, fill = drv, color=  drv), size = 3)


# Problem 3.7.1
#1 - default geom - "pointrange"
tmp <- diamonds %>% group_by(cut) %>% summarise( medval = median(depth), min = min(depth), max = max(depth))
ggplot( data = tmp, mapping = aes(x = cut, y = medval, ymin = min, ymax = max)) +
  geom_pointrange()

#2
?geom_col
#Geom col defaulrs to using the actual values of the data
# Geom bar uses stat_count by default, geom_col uses stat_identity

#3
# ?geom_point - identity
# ?geom_bar - stat_count
# ?geom_column - stat_identity
# ?geom_area - stat_identity
# ?geom_histogram - stat_bin
# ?geom_path - stat_identity 
# ?geom_line - stat_identity
# ?geom_boxplot - stat_boxplot

#4
# ?stat_smooth - shows smoothed trend in data (helpful for visually interpreting data)
# takes standard mapping & data, 'method' for the way smoothing is done (rlm, loess etc... )
# formula - what relation is being determined (~x,y)
# se - confidence intervals, n - number of points, level - level of confidence, fullrange - fit whole plot or just data

  
#5
#Without group = 1 each x aes is mapped proportionally to itself - so each x cut shows up as a 100% proportion

# Problem 3.8.1 

#1) 
# Overplotting (some points get doubled up) - fix with jitter
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point() + 
  geom_jitter()
#2)
?geom_jitter
# Standard mapping, data, ...,  stat, na.rm, show.legend args for all geoms
# width/height to adjust the size of the jitter
#position to well, adjust the position

#3)
#Geom_count can also be used to deal with over-fitting
#instead of jittering overplotted points it makes them bigger to show that more of them exist

#4)
?geom_boxplot
#Default is dodge

ggplot(data = mpg) + 
  geom_boxplot(mapping = aes(x = drv, y = cty, fill = class), position = "dodge")

# Problem 3.9.1
#1) Stacked Bar Chart to polar:
ggplot(data = diamonds, aes(x = cut, fill = clarity)) +
  geom_bar() +
  coord_polar()

#2) labs() provides axes and title lables for plots
?labs
#3)
?coord_map
?coord_quickmap
# Both plot maps  onto 2D planes - but coord_quickmap preserves straight lives. quickmap is better closer to the equator since it is a quicker computation
# coordmap requires much more computation 

#4) 
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline() +
  coord_fixed()
?geom_abline # provideds reference lines to the plot - can specify slope/intercept if you want
?coord_fixed # forces scale on the x vs y axis (default is 1 to 1): puts relative slop of relation in perspective so scaling doesn't skew view

# Ch. 4 Problems ----------------------------------------------------------
#4.4
#1)  The "i" in the 2nd my_variable isn't actually an i
#2) 
ggplot(data = mpg) + 
geom_point(mapping = aes(x = displ, y = hwy))
filter(mpg, cyl == 8)
filter(diamonds, carat > 3)
# 3) Shows Shortcut commands - Menu -> Tools -> Keyboard Shortcuts Help

# Ch. 5 Problems ----------------------------------------------------------
#5.2.4
#1)
library(tidyverse)
library(nycflights13)
filter(flights, arr_delay >= 120)
filter(flights, dest == 'IAH' | dest == 'HOU')
filter(flights, carrier %in% c('UA', 'AA', 'DL'))
filter(flights, month %in% c(7,8,9))
filter(flights, arr_delay >= 120 & dep_delay <= 0)
filter(flights, dep_delay >= 60 & dep_delay - arr_delay >= 30)
filter(flights, dep_time >= 0 & dep_time <=600)
#2) limits an observation between two values
filter(flights, between(month, 7, 9))
filter(flights, between(dep_time,0,600))

#3) 
filter(flights, is.na(dep_time))
#No arrival time or air time - looks to be flights that got cancelled and never took off

#4)
NA ^ 0 #ANYTHING raised to the 0 is 1, so regardless of what value coudl be in NA it would be 1
NA | TRUE #Regardless of what NA could be, true will always be true and with the | statement it will always return true
NA | FALSE #Returns NA
NA & FALSE #Even if NA were to be true (or any value) - false is always false and will override the & statement as such
NA & TRUE #Returns NA
# If changing the value of NA would alter the outcome of the operation, then it will kick back NA. 
# But if NA changing will not change the output, then the function can actually return True, false etc...
# NA * 0 is a counter example because technically infinity * 0 doesn't evaluate to a value, so NA* 0 is not always = 0 (my theory at least)


#5.3.1

#1 ) 
arrange(flights, desc(is.na(dep_time)))

#2)
#Most delayed flights
arrange(flights, desc(dep_delay))
#Flights that left earliest (earliest time of day)
arrange(flights, dep_time)

#3) 
arrange(flights, distance)
#4)
arrange(flights, desc(air_time))
arrange(flights, air_time)

#5.4.1
#1)
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, starts_with('dep'), starts_with('arr'))
select(flights, contains('dep'), contains('arr'), (-contains('sched')))
select(flights, ends_with('time'), ends_with('delay'), -contains('sched'), -contains('air'))
#Could get continually more broad with select and then more specific with the -contains() to get rid of any columns we don't want
#Could also use matches() with a regex\

#2)
select(flights, dep_time, dep_time) #only selects it once

#3)
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(vars))
#Allows you to select columns whose names match values in a character vector - useful if you want to pre-define vars up front generically

#4)
select(flights, contains("time", ignore.case = FALSE))
#Not case sensitive by default - use ignore.case

# Ch. 6 Problems ----------------------------------------------------------
flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)


#5.5.2
#1)
select(mutate(
  flights, 
  sched_dep_minutes_since_midnight = (sched_dep_time %/% 100)*60 + sched_dep_time %% 100 ,
  dep_minutes_since_midnight = (dep_time %/% 100)*60 + dep_time %% 100 
  
), sched_dep_time, dep_time, sched_dep_minutes_since_midnight, dep_minutes_since_midnight
)

#2) 
flights %>% mutate(arr_dep_diff = arr_time - dep_time, arr_dep_minute_diff = (arr_dep_diff %/% 100)*60 + arr_dep_diff %% 100) %>% 
  select(air_time, arr_time, dep_time, arr_dep_diff, arr_dep_minute_diff)
# air_time should be the difference between arr_time and dep_time - but just subtracting doesn't provide result
# need to take the difference (in hour minute format) & convert to total minutes using modular arithmatic
# Numbers are still different - most likely because we aren't accounting for time zone changes but air_time function is

#3) 
flights%>%  select(dep_time, sched_dep_time, dep_delay)
#dep_Delay is the difference between the other 2

#4) 
flights %>% mutate( delayRank = min_rank(desc(dep_delay))) %>% select(dep_delay, delayRank) %>% arrange(delayRank)
# Can use dense_rank to have ties remain ties - min_rank will arbitrarily assign an ordering to ties


#5) 
1:3 + 1:10 
#Returns error: trying to add vectors of different lenghts (3 vs 10)

#6) 
?Trig
# cos(x)
# sin(x)
# tan(x)
# 
# acos(x)
# asin(x)
# atan(x)
# atan2(y, x)
# 
# cospi(x)
# sinpi(x)
# tanpi(x)

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

by_day <- group_by(flights, year, month, day)
by_day
flights
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

#5.6.7
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

#1)
#a) Scatterplot to look at the variance of delays for each specific flight compared to teh avg delay time-
  #will help determine if it's a few fligths consistently delayed or sporadically a lot of flights
#b) #Bucket counts of flights 0-10 min late, 10-20 min late etc... Determine if it's a lot of flights a few minutes late vs a few flights very late
#c) #Look at a ration of pct early vs pct late - bucket by this percent and then look at counts for each bucket
#d) Plot mean delays compared to time of day - see if delays are worse during certain parts of the day
#e) Plot variance in delays compared to time of day - see if those times of day that are worse are caused by a few extreme flights or by all flights being slightly worse
#Departure delay is more important - will be indicative of the expected arrival delay

#2) 
not_cancelled %>% count(dest)
not_cancelled %>% group_by(dest) %>% summarise(n())
not_cancelled %>% count(tailnum, wt = distance)
not_cancelled %>% group_by(tailnum) %>% summarise(wt = sum(distance))

#3)
#Definition is only looking to see if there is no NA value in the delay columns
#We should really be looking at the dep_time & arr_time as a hard rule for if the flight departed & landed

#4)
flights %>% group_by(year, month, day) %>% summarise(cancelled = sum(is.na(dep_time)), avgDelay = mean(dep_delay, na.rm = TRUE)) %>% 
  ggplot(aes(x = avgDelay, y = cancelled)) +
  geom_point() + 
  geom_smooth()
#Looks to be a corroloation between the avg delay and number of flights cancelled
# Not very strong but present
# Probably mostly corrolated to weather patterns in NY

#5)
#see if there's a visual trend in the data
flights %>% group_by(carrier, dest) %>% summarise(total = n(), meanDel = mean(dep_delay, na.rm = TRUE)) %>% 
  filter(total > 1000) %>% 
  ggplot(aes(x = dest, y = meanDel, group = carrier, fill = carrier)) + 
  geom_bar(stat = "identity", position = "dodge") + 
  coord_flip()
#From the graph, across multiple airports it looks to be EV

#6) 
tmp <- flights %>% count(dest, sort(origin))
# Provides a sorted ordering of another variable - also breaks out by that variable similar to group_by
# Good for organizing/summarizing data

#5.7.1

#1) 
# summarise() - summarises functions based on the groups, not the overall data set
# mutate() - preforms function of new column relative the group each row is in
#filter() - limits each set of data respective to its own group

#2)
flights %>% group_by(tailnum) %>% 
  summarise(avgArrDelay = mean(arr_delay, na.rm = TRUE)) %>% 
  filter(rank(desc(avgArrDelay)) == 1)
# Worst Avrage Arrival Delay is N844MH

#3) 
flights %>% mutate(the_hour = sched_dep_time %/% 100) %>% 
  group_by(the_hour) %>% 
  summarise(avg_delay = mean(dep_delay, na.rm = TRUE)) %>% 
  arrange(rank((avg_delay))) %>% 
  ggplot(aes(x = the_hour, y = avg_delay)) +
  geom_bar(stat = "identity")
#Flights from 5am - 6am are the lease delayed

#4)
# Total minutes of delay for each destination
flights %>%
  # filter(dep_delay >= 0) #Optional to exclude flights that left early
  group_by(dest) %>% summarise(total_delays = sum(dep_delay, na.rm = TRUE))

#proportion of delay to destination by flight
flights %>% group_by(dest) %>% mutate(delay_prop = dep_delay/sum(dep_delay, na.rm = TRUE)) %>% 
  select(year:day, dep_delay, delay_prop)

#5)
flights %>% arrange(year, month, day, sched_dep_time) %>% 
  na.omit() %>% 
  mutate(dep_delay_flight_before = lag(dep_delay)) %>% 
  select(year:day, sched_dep_time, dep_delay, dep_delay_flight_before)
  ggplot(aes(x = dep_delay_flight_before, y = dep_delay)) +
  geom_point(alpha = 0.4)
 #Scatter plot to show any trends in delays 
  
  
#6)
  #look at quickest flight to each destination (which ones had most distance per airtime)
  flights %>% group_by(dest) %>% 
    mutate(est_speed = distance/air_time) %>% 
    select(dest, air_time, distance, est_speed, tailnum) %>% 
    filter(rank(desc(est_speed)) < 3) %>% 
    arrange(desc(est_speed))
# Record having flight N666DN take 65 min to go from NY to Atlanta
# many other similar records  
  
  flights %>% group_by(dest) %>% 
    mutate(time_rel_shortest_flight = air_time/min(air_time, na.rm = TRUE)) %>% 
    select(year:day, air_time, time_rel_shortest_flight, tailnum) %>% 
    arrange(desc(time_rel_shortest_flight))
# Most delayed in air: tailnum N37255 to BOS on 6/24
# Many of the 'most delayed' are to Boston - probably becase the min(air_time) is only like 20 mins, so a 20 min delay is a 100% change

#6) All destinations with more than 1 carrier
  flights %>% group_by(dest) %>% summarise(total_carriers = n_distinct(carrier)) %>% 
    filter(total_carriers > 1)
# Rank carriesr on how many destinations they go to
  flights %>% group_by(carrier) %>% summarise(destinations = n_distinct(dest)) %>% 
    arrange(rank(desc(destinations)))
#7) Interpreting question as plane took off before any delay and had air_time more than 1 hour
  flights %>% group_by(tailnum) %>% 
    filter(air_time > 60 & dep_delay <= 0) %>% 
    count()

  # Ch. 7 Problems ----------------------------------------------------------

#7.3.4) 
  #1) 
  ggplot(diamonds, aes(x = x)) + 
    geom_histogram(binwidth = 0.5) + 
    coord_cartesian(ylim = c(0, 50))
  
# most x values between 3 and 10, few outliers at 0
  ggplot(diamonds, aes(x = y)) + 
    geom_histogram(binwidth = 0.5) + 
    coord_cartesian(ylim = c(0, 50))
  
# most y values between 5 and 11, less than 10 outliers at 0, 30, 60
  
  ggplot(diamonds, aes(x = z)) + 
    geom_histogram(binwidth = 0.5) + 
    coord_cartesian(ylim = c(0, 50))
# z values range from 3 to 6, outlier at 30 and a few at 0
  #Honestly with my ignorance of diamonds I have no idea what lenght, width & depts would relate to x, y, z
#2) 
  ggplot(diamonds, aes(x = price)) + 
    geom_histogram(binwidth = 10) 
  # most diamonds centered around $500 - $1500
  # strangely no diamonds priced between 1460 and 1540...
  # but still plenty of diamonds up around $15000
  # None more that ~$17000
  ggplot(diamonds, aes(x = price)) + 
    geom_histogram(binwidth = 1000) 
  
#3)
  diamonds %>% filter(carat == .99) %>% count()
#23 diaomonds of .99 carat
  diamonds %>% filter(carat == 1) %>% count()
#1588 diamonds of 1 carat - it's probably easier to just round up. Also 1 carat sounds better than .99 so those measuring have incentive to fudge the truth
  
#4)  
  ggplot(diamonds, aes(x = price)) + 
    geom_histogram() +
    coord_cartesian(xlim = c(0,5000))
    
  #coord_cartesian doesn't change data, just adjusts zoom of plot
  # bin sizes are default chosen by ggplot based on the data set 
  # bin size of about 700 on price, bin size of about 0.14 on carat 
  
  ggplot(diamonds, aes(x = price)) +
    geom_histogram() +
    xlim(0,4000)
  # using xlim or y lim will actually get rid of values outside the limit
  # xlim will actually reset the bin size if it's left to the default

  #7.4.1
#1)
  ggplot(diamonds, aes(x = cut)) +
    geom_bar()
  ggplot(diamonds %>% mutate(cut1 = ifelse(cut == 'Good', NA, cut)), aes(x = cut1)) + 
    geom_bar()
  ggplot(diamonds, aes(x = carat))+
    geom_histogram()
ggplot(diamonds %>% mutate(carat1 = ifelse(carat < .5, NA, carat)), aes(x = carat1))+
  geom_histogram()
  
#missing values in histogram won't show up at all since they can't be plotted on continuous scale
# For a bar chart if you're just plotting a count then those values also won't show
# But if on a bar chart your're plotting an identity for some x value, and then identity value is NA then the x value will still show up on the x axis, but won't have any value associated with it

#2) 
# na.rm = TRUE ignores NA values when calculating sums or means 
# a sum or mean can't be calculated if any values are NA and they will thus also become NA, so NAs should be ignored

#7....

#7.5.1.1
#1) nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(x = sched_dep_time, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1)

  #2) 
  ### Strategy only works for factor variables - check color, clarity, cut 
  ggplot(diamonds, aes(x=price, y = ..density..)) +
    geom_freqpoly(mapping = aes(color = color), binwidth = 2000)
  ### Change the color aes to see which different variables skew more towards higher prices
  # don't see any trends - Color I slightly higher prices
  
  #Do different kind of plot for continuous variables
  ggplot(diamonds %>% mutate(size = x*y*z), aes(x = size, y = price)) +
    geom_point(alpha = .3) + 
    coord_cartesian(xlim = c(0,500)) + 
    geom_smooth()
  
  ggplot(diamonds, aes(x = carat, y = price)) +
    geom_point()
  # Size (combination of x, y, z) seems to be most indicative of the price of a diamond
  # See similar relationship between carat and price
  # I just googled it and apparently carat is a unit of weight for diamonds - so it correlates with my 'size' measurement
  #Compare Size/Carat to cut
  ggplot(diamonds %>% mutate(size = x*y*z), aes(x = size, y = ..density..)) +
    geom_freqpoly(aes(color = cut), binwidth = 20) +
    coord_cartesian(xlim = c(0,500))
  ggplot(diamonds, aes(x = carat, y = ..density..)) +
    geom_freqpoly(aes(color = cut), binwidth = .1) +
    coord_cartesian(xlim = c(0,4))
  
  # Better cut diamonds tend to be much smaller (in 'size' and carat)
  # So since lower cut diamonds are larger, they can end up being more expensive
  
#3)
#  install.packages("ggstance")
 library(ggstance) 
  
  ggplot(diamonds, aes(x = cut, y = price)) + 
    geom_boxplot() +
    coord_flip()
  
  ggplot(diamonds, aes(x = price, y = cut)) +
    ggstance::stat_boxploth()
# Using ggstane have to reorder your x and y variables from using coord_flip  

#4) 
#  install.packages("lvplot")
library(lvplot)  

    ggplot(diamonds, aes(x = cut, y = price)) +
    geom_lv()
    
    ?geom_lv
    #Is more enocompasing and represents more 'outliers' since we expect more of these in larger data sets
    # Creates an area (representative of distribution density) to show where values are
    # Still shows outliers as points - but much fewer values are considered outliers in this method
#5) 
ggplot(diamonds, aes(x = price)) +
  geom_histogram(binwidth = 1000) + 
  facet_grid(cut~.)

ggplot(diamonds, aes(x = price))+
  geom_freqpoly(aes(color = cut), binwidth = 1000)

ggplot(diamonds, aes(x = cut, y = price)) + 
  geom_violin()
# lol they kinda look like violins

# Violin - good for side by side comparisons of densitys, but doesn't represent the raw counts - but keeps all factors separate which is good if there are a lot of factors
# Facted - very easy to look at each data set individually but comparing trends (as seen from density) is difficult
# frequpoly - good for comparing and overlaying the data (easy to see where densities mismatch) - but with too many breakouts the plot can get messy quickly

#6) 
#install.packages("ggbeeswarm")
library("ggbeeswarm")
?ggbeeswarm::geom_beeswarm
#creates randomness to reduce overplotting - shifts either on x or y
ggplot(mpg, aes(x = cyl, y = displ )) +
  geom_point() +
  geom_beeswarm()

?ggbeeswarm::geom_quasirandom

#Similar to beeswarm but shifts points by quasirandom amount
# can define way in which points get distributed
ggplot(mpg, aes(x = cyl, y = displ )) +
  geom_quasirandom( method = "smiley")

?ggbeeswarm::position_beeswarm
# scatters points, can specify x or y, similar to geom_beeswarm
# Must define within the position of geom_point() (or other geoms)
# Can't be added (+) to a plot like geom_beeswarm
ggplot(mpg, aes(x = cyl, y = displ )) +
  geom_point(position = position_beeswarm())

?ggbeeswarm::position_quasirandom
# Like geom_quasirandom but is defined within geom_point() or other geoms
# Can have variables defined similarly as geom_quasirandom
ggplot(mpg, aes(x = cyl, y = displ )) +
  geom_point(position = position_quasirandom(method = "smiley"))


#7.5.2.1
#1) 
diamonds %>% 
  count(color, cut) %>% 
  group_by(cut) %>% mutate(pctMix = n/sum(n)) %>%  #see how color is distributed across cut
ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = pctMix))
# In this graph summing across cut will sum to 1

diamonds %>% 
  count(color, cut) %>% 
  group_by(color) %>% mutate(pctMix = n/sum(n)) %>%  #see how cut is distributed across color
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = pctMix))
# In this graph summing across color will sum to 1

#2) 

flights %>% 
  group_by(month, dest) %>% summarise(avgDelay = mean(dep_delay, na.rm = TRUE)) %>% 
  ggplot(aes(x = month, y = dest)) +
  geom_tile(aes(fill = avgDelay))
# Lots of data points (12 months, 105 dest) - so super granular
# some destinations didn't have flights in some months so no present data


#Limit to airports that had more than N flights in a year
# Gets rid of a lot of small data but shows larger trend
N <- 1200
bigAirports <- flights %>% group_by(dest) %>% summarise(totalFlights = n()) %>% 
  filter(totalFlights > N) %>% 
  select(dest)

flights %>% 
  group_by(month, dest) %>% summarise(avgDelay = mean(dep_delay, na.rm = TRUE), totalFlights = n()) %>% 
filter(dest %in% c(bigAirports[[1]])) %>% 
ggplot(aes(x = month, y = dest)) +
  geom_tile(aes(fill = avgDelay))

#3)
diamonds %>% 
  count(color, cut) %>%  
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))

diamonds %>% 
  count(color, cut) %>%  
  ggplot(mapping = aes(y = color, x = cut)) +
  geom_tile(mapping = aes(fill = n))

#All it does is switch the rows/columns of the graph -- all information remains the same
# Aestetic choice for who is looking at the graph - if they want to scan across color or cut horizontally

#7.5.3.1 

#1 & #2)
smaller <- diamonds %>% filter( carat < 3)
# For cut width we need to be aware of the values of carat and define widths that make sense
# Max carat is 3, so we'll need widths smaller than that
cwid = .5
 ggplot(smaller, aes(x = price, y = ..density..)) +
   geom_freqpoly(aes(group = cut_width(carat, cwid), color = cut_width(carat, cwid)), binwidth = 1000)
 
 # For cut_number we just need to know how many 'bins' we want our distinction on carat to be
 cnum = 10
 ggplot(smaller, aes(x = price, y = ..density..)) +
   geom_freqpoly(aes(group = cut_number(carat, cnum), color = cut_number(carat, cnum)), binwidth = 1000)
 
 #3) Larger diamonds (as expected) have a higher distribution around higher prices, and smaller diamonds towards lower prices
 
 #4)
#Use geom_tile to compare average prices across cut & carat
 
 #Break carat out using cut_width
  smaller %>% 
   group_by(cut, caratGroup = cut_width(carat, .5)) %>% 
   summarise(avgPrice = mean(price, na.rm = TRUE)) %>% 
   ggplot(aes(x = cut, y = caratGroup)) +
   geom_tile(aes(fill = avgPrice))
 # Look at it with carat broken into 8 even sized buckets (same number of diamonds in each)
 smaller %>% 
   group_by(cut, caratGroup = cut_number(carat, 8)) %>% 
   summarise(avgPrice = mean(price, na.rm = TRUE)) %>% 
   ggplot(aes(x = cut, y = caratGroup)) +
   geom_tile(aes(fill = avgPrice))
 
 #5) 
 # A scatterplot will show the exact points as outliers - they're impossible to visually miss
 # For a bin plot, each bin coloring is based on the frequency of points
 # If some bins have thousands of points, it becomes difficult to visually distinguish between bins with 0 points and bins with 1 since their colors will be so similar
 
getwd()
 