# Flood Data

## Overview

The goal of this project is to predict flooding in advance, using a variety of
different datasets.

## Data

The following are the datasets that have been incorporated into this project:

### KBDI

* Source: http://flame.fl-dof.com/cgi-bin/KbdiArchiveListing.py
* Relevant scripts:
  * `kbdi_scraper.py`
  * `read_data.R`
* Relevant directories: data/kbdi
* Date Range: 2011-01-01 - current

#### Description

KBDI stands for "Keetch Byram Drought Index". For more information, visit the
[Florida Department of Agriculture and Consumer Services page](http://www.freshfromflorida.com/Divisions-Offices/Florida-Forest-Service/Wildland-Fire/Keetch-Byram-Drought-Index-KBDI) or the
[Wikipedia page](https://en.wikipedia.org/wiki/Keetch%E2%80%93Byram_drought_index).

These are archived reports, which show daily values for each of the following:

* Mean KBDI
* Change in KBDI
* Min KBDI
* Max KBDI
* Percentage of area in each range of the KBDI scale (0-100, 100-200, ...,
700-800)

Each day's raw report shows these metrics at the state, district, and county
levels.  `read_data.R` reads in all the daily reports and creates three
aggregated .csv files, one for each level of geographic granularity.

### Waterwatch

* Source: http://waterwatch.usgs.gov/index.php?region_cd=fl&map_type=pa01d&web_type=table2
* Relevant scripts:
  * `sh/waterwatch_cur_resources.sh`
  * `awk/waterwath_cur_resources.awk`
* Relevant directories: data/waterwatch
* Date Range: 2001-01-16 - current

#### Description

This data contains daily information about streamgages in Florida. It is a
single table that covers the entire date range. For an explanation of how this
data is derived, see the [explanation page](http://waterwatch.usgs.gov/htmls/ptile_table_d.html).

To obtain this data, click on the "...View the complete table" link. In your
browser, save the table as
`waterwatch__maps_and_graphs_of_current_water_resources_conditions.html`.  Put
this file in the `data/waterwatch/` directory. (That file is already included
in this repository). Then run `sh/waterwatch_cur_resources.sh`. The final
version of this data will appear in the output file
`waterwatch_cur_resources.tsv` in the same directory as the input file.
