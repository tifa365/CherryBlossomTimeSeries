# Import required libraries
import pandas as pd
from plotnine import *
from plotnine.data import *

# Read the data file
cherry = pd.read_excel("KyotoFullFlowerW.xls", skiprows=15, usecols="A:E", names=["year", "yday", "anomaly", "city", "reference"])

# Filter out rows with NA values in the Full-flowering date (DOY) column
cherry = cherry[~cherry['yday'].isna()]

# Filter out rows with NA values in the year column
cherry = cherry[~cherry['year'].isna()]

# Convert yday and year to integers
cherry['yday'] = cherry['yday'].astype(int)
cherry['year'] = cherry['year'].astype(int)

# Calculate y-axis tick positions and labels
y_dates = pd.to_datetime(["3-20", "4-1", "4-10", "4-20", "5-1", "5-10"], format="%m-%d")
y_ticks = y_dates.dayofyear
y_lab = y_dates.strftime("%b %d")

# Create the plot
p = ggplot(cherry, aes(x="year", y="yday")) + \
    theme_bw() + \
    theme(panel_grid=element_blank(), 
          axis_text=element_text(size=10),  # smaller X and Y axis labels
          axis_title=element_text(size=14), 
          panel_background=element_rect(fill="#E0D5C4"), 
          plot_background=element_rect(fill="#E0D5C4"), 
          legend_background=element_rect(fill="#E0D5C4")) + \
    ggtitle("Full-flowering Date of Cherry Blossoms in Kyoto, Japan") + \
    geom_line() + \
    geom_smooth(color="black") + \
    scale_y_continuous(breaks=y_ticks, labels=y_lab) + \
    scale_x_continuous(breaks=[812, 1000, 1250, 1500, 1750, 2000], expand=(0.01, 0)) + \
    labs(x="Year", y="Full-flowering date (DOY)") + \
    theme(figure_size=(8, 4))

# Print the plot
print(p)

# Save the plot to a high-resolution file
ggsave(plot=p, filename="cherry_blossoms_plot_python.png", dpi=300)
