# This file takes the following as its input file:
# data/waterwatch/waterwatch__maps_and_graphs_of_current_water_resources_conditions.html

BEGIN{

    # field-separator in output file will be tab
    OFS="\t"

    # print the header row
    print "Date", "Pct_stns_class_1", "Pct_stns_class_2", "Pct_stns_class_3", "Pct_stns_class_4", "Pct_stns_class_5", "Pct_stns_class_6", "Pct_stns_class_7"
}

# only grab lines where the first field is all digits, and the total number of fields is 9
($1 ~ /^[0-9]+$/ && NF == 9) {

    # format the date using the function below and then append the rest of the fields using the field separator specified above
    print format_date($1), $2, $3, $4, $5, $6, $7, $8, $9
}

# helper function to format date strings appropriately
function format_date(date_str) {
    year = substr(date_str, 1, 4)    
    month = substr(date_str, 5, 2)
    date = substr(date_str, 7, 2)

    return year "-" month "-" date
}
