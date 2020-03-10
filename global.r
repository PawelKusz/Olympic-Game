axis_vars <- c(
  "Year" = "Year",
  "Height"="Height",
  "Weight"="Weight",
  "Age"="Age"
)

sports <- read.csv2("sports.csv")
sports <- sports$x

nations <- read.csv2("nations.csv")
nations <- nations$x