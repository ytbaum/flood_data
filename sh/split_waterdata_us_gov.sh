#!/bin/bash

# the directory this script lives in
SCRIPT_DIR=`cd $(dirname "$0") && pwd`

PROJ_ROOT=$SCRIPT_DIR/..
AWK_DIR=$PROJ_ROOT/awk
DATA_DIR=$PROJ_ROOT/data

# will output to data/waterdata_us_gov/station_<station-number>.tsv
awk -f $AWK_DIR/split_waterdata_us_gov.awk $DATA_DIR/waterdata_us_gov/dv_data.tsv
