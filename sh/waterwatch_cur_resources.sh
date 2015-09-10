#!/bin/bash

# This script is just a wrapper for
# awk/waterwatch_cur_resources.awk

set -eu

# the directory this script lives in
SCRIPT_DIR=$(dirname "$0")

PROJ_ROOT=$SCRIPT_DIR/..
AWK_DIR=$PROJ_ROOT/awk
DATA_DIR=$PROJ_ROOT/data

# convert waterwatch table from .html file to .tsv file
awk -f $AWK_DIR/waterwatch_cur_resources.awk $DATA_DIR/waterwatch/waterwatch__maps_and_graphs_of_current_water_resources_conditions.html > $DATA_DIR/waterwatch_cur_resources.tsv

