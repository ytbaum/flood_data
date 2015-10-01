# run this from project root directory

BEGIN{
    OFS="\t"

    # print appropriate headers at the beginning of each different file
    station_02321500_file = "data/waterdata_us_gov/station_02321500.tsv"        
    print "agency", "site_no", "date",  "discharge_mean_ft_3_s", "discharge_mean_ft_3_s_code", "mean_gage_height_ft", "mean_gage_height_ft_code", "mean_feet_above_navd_1988", "mean_feet_above_navd_1988_code" > station_02321500_file

    station_02322049_file = "data/waterdata_us_gov/station_02322049.tsv"
    print "agency", "site_no", "date", "mean_gage_height_ft", "mean_gage_height_ft_code", "discharge_mean_ft_3_s", "discharge_mean_ft_3_s_code" > station_02322049_file
}

($2 ~ /^[0-9]+$/ && $1 != "#"){

    # output data into separate files, one file per streamgage station
    # (streamgage station is identified by field 2)
    output_file = "data/waterdata_us_gov/station_" $2 ".tsv"
    print >> output_file
}
