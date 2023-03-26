# More info in readme.txt

# Install and load the pacman package
if (!requireNamespace("pacman", quietly = TRUE)) {
  install.packages("pacman")
}
library(pacman)

# Install and load required packages from CRAN
p_load(
  readxl,
  ggplot2,
  ggpubr,
  lubridate,
  jpeg,
  showtext
)

# Install and load emoGG package from GitHub
if (!requireNamespace("emoGG", quietly = TRUE)) {
  p_load(devtools)
  devtools::install_github("dill/emoGG")
  library(emoGG)
} else {
  library(emoGG)
}

# Load the required libraries
library(readxl)
library(ggplot2)
library(emoGG)
library(ggpubr)
library(lubridate)
library(jpeg)
library(showtext)

# Automatically use showtext for new devices
showtext_auto()

# Register the Google Font "M PLUS 1p"
font_add_google("M PLUS 1p", "mplus1p")

# Download KyotoFullFlowerW.xls data file
url <- "https://www.ncei.noaa.gov/pub/data/paleo/historical/phenology/japan/KyotoFullFlowerW.xls"
destfile <- "KyotoFullFlowerW.xls"
download.file(url, destfile, mode = "wb")

# Read the data file
cherry <- read_xls(path = "KyotoFullFlowerW.xls",
                   col_names = TRUE, col_types = c("numeric", "numeric", "numeric", "text", "text"), range = "A16:E1226")

# Filter out rows with NA values in the Full-flowering date (DOY) column
cherry <- cherry[!is.na(cherry$`Full-flowering date (DOY)`), ]

# Rename the first two columns
colnames(cherry)[1:2] <- c("year", "yday")

# Read the background image
fuji <- readJPEG("fuji.jpg")

# Calculate y-axis tick positions and labels
y.dates <- parse_date_time(c("3-20", "4-1", "4-10", "4-20", "5-1", "5-10"), orders = "md")
y.ticks <- yday(y.dates)
y.lab <- format(y.dates, "%b %d")

# Create the plot
p <- ggplot(data = cherry, aes(x = year, y = yday)) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        axis.text = element_text(size = 18, family = "mplus1p"),
        axis.title = element_text(size = 22, family = "mplus1p"), 
        # specified background color that is closer to image than pure white
        panel.background = element_rect(fill = "#E0D5C4"),
        plot.background = element_rect(fill = "#E0D5C4"),
        legend.background = element_rect(fill = "#E0D5C4")) +
  background_image(raster.img = fuji) +
  geom_line() +
  geom_emoji(emoji = "1f338", size = .025) +
  geom_smooth(color = "black") +
  scale_y_continuous(name = element_blank(), breaks = y.ticks, labels = y.lab) +
  scale_x_continuous(name = "Year", breaks = c(812, 1000, 1250, 1500, 1750, 2000), expand = c(.01, 0))

# Print the plot
print(p)

# Set the plot dimensions in inches (width x height)
plot_width <- 8
plot_height <- 4

# Save the plot to a high-resolution file
ggsave(filename = "cherry_blossoms_plot.png",
       plot = p,
       width = plot_width,
       height = plot_height,
       dpi = 300)
