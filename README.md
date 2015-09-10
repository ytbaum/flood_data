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
* Date range: 2011-01-01 - current

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
* Date range: 2001-01-16 - current

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

### USGS Data

* Source: http://waterdata.usgs.gov/fl/nwis/gw/. This is actually a portal to 
several different datasets. Steps for obtaining the data:
  * For `dv_sites.tsv`:
    1. Click "Daily Data"
    2. Under “Site Location”, check “Alachua County”.  Un-check "Site Type" and any other boxes that might be selected by default.  Click “Submit”.
    3. Under “County”, select “Alachua County”. 
    4. Under “Choose Output Format”, select “Site-description information displayed in” and in the drop-down menu choose “--saved to compressed file”.
    5. In the multi-select list labeled “(Select fields to include in site-description output)”, Shift-click to select all possible values.
    6. Scroll to the bottom of the page and click “Submit”.
    7. This will download a file named `dv`.  Note that this is a file compressed
    using the 'gunzip' format.  To uncompress it, rename the file to `dv.gz` and
    then run gunzip on it (`gunzip dv.gz` at the linux commandline).  Rename the
    file to `dv_sites.tsv`.
  * For `dv_data.tsv`:
    1. repeat steps 1-4 as above.
    2. Under “Retrieve USGS Groundwater Daily Data for Selected Sites” →
    “Retrieve data for:”, select the desired date range (in this case, 1/1/2005
    through 9/2/2015).
    3. Under “Output options”, select “Tab-separated data”, “YYYY-MM-DD”, and
    “Save to compressed file”.
    4. Repeat steps 7 and 8 from above, except that instead of renaming the
    final file to `dv_sites.tsv`, rename it to `dv_data.tsv.`
* Relevant scripts: no scripts to process this data have been added yet.
* Relevant directories: `data/waterdata_us_gov`
* Date range: varies by USGS station (see data).

#### Description

See the explanation page at http://help.waterdata.usgs.gov/faq/about-tab-delimited-output.
