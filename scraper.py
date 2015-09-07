from bs4 import BeautifulSoup
import urllib2
import re
import string as str
import os

# Helper functions, which will be referred to below

def is_valid_row(elt):
    return elt.name == "tr" and len(elt.contents) > 5

def get_text(column):
    node = column.find("font")
    if node == None:
        return ""
    else:
        return node.find(string=True)

def get_filename(link):
    splits = str.split(link, "/")
    report_html_file = splits[len(splits) - 1]
    filename = str.replace(report_html_file, ".html", ".csv")
    return filename

# Initialize output directory

data_dir = "data/kbdi/"
if not os.path.exists(data_dir):
    os.makedirs(data_dir)    

# Initialize scraper

domain = "http://flame.fl-dof.com/"
start_url = domain + "/cgi-bin/KbdiArchiveListing.py"
page = urllib2.urlopen(start_url)
page_reader = BeautifulSoup(page.read(), "lxml")

# For each report, scrape the contents and write to a .csv

links = page_reader.find_all("a", href = re.compile("archive/kbdi-report-20"))

for link in links:
    report_href = link['href']
    report_filename = get_filename(report_href)
    output_filename = data_dir + report_filename

    report_url = domain + report_href
    report_reader = BeautifulSoup(urllib2.urlopen(report_url), "lxml")

    output_file = open(output_filename, 'w')

    print("Now writing to " + report_filename + "...")

    table_rows = report_reader.find_all(is_valid_row)

    for row in table_rows:
        columns = row.find_all(["th", "td"])
        column_texts = []
        for column in columns:
            text = get_text(column)
            if text == u'\xa0' or text == None:
                text = ""
            column_texts.append(text)

        output = str.join(column_texts, ",") + "\n"
        output_file.write(output)

    output_file.close()

print "Done."
