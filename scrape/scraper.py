from requests import post
from requests import get
from bs4 import BeautifulSoup
import traceback
import sys
import re
import csv
import time

foia_data = []


with open("2014-urls.txt") as f:
    raw_lines = f.readlines()
    urls = [line.strip() for line in raw_lines]

head_data = {"User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36",
             "From":"rsk2161@columbia.edu"}

errors = open("errors.txt", 'w')
error_counter = 0

headers = ["url", "tracking number", "name", "organization", "date_submitted", "closed_date", "final_disposition", "description"]

with open("2014-results.csv", "a") as output_file:
    wr = csv.writer(output_file)
    wr.writerow(headers)

for url in urls:
    
    info_list = []

    try:
        
        info_list = []
        info_list.append(url)

        response = get(url, headers=head_data)
        data = response.text

        soup = BeautifulSoup(data, 'html.parser')

        # Once we've parsed the data, we're going to use .find() and .find_all() to navigate the html structure of the page
        # looking for specific "div" tags or classes is sort of "arbitrary"
        # which is to say, ompletely based on how someone *happened* to structure the html layout of this page
        
        # Grab tracking number
        tracking = soup.find("div", {"class":"subHeaderRight"})
        tracking_number = tracking.find("em").text

        if tracking_number:

            info_list.append(tracking_number)
        
        else:
            info_list.append("not found")

        # grab data from left side of table

        leftside = soup.find("div", {"class":"subContentLeft"})
        labelsl = leftside.find_all("div", {"class":"formitem"})

        cleaned_labels1 = []

        # Need to clean up the 
        cleaned_labels1 = []
        for label in labelsl:
            yuck = label.text
            clean = yuck.split(":")
            cleaned_labels1.append(clean[1].strip())

        name_label = re.sub('Mr\.\s+|Ms\.\s+|Mrs\.\s+', '', cleaned_labels1[0])
        org_label = cleaned_labels1[1]


        # See if we could grab name, save it 
        if name_label:
            info_list.append(name_label)
        else:
            info_list.append("not found")

        # See if we could grab the org name, save it

        if org_label:
            info_list.append(org_label)
        else:
            info_list.append("not found")

        # Grab data from right side of table
        rightside = soup.find("div", {"class":"subContentRight"})
        labelsr = rightside.find_all("div", {"class":"formitem"})

        cleaned_labelsr = []

        for labelr in labelsr:
            yuck = labelr.text
            clean = yuck.split(":")
            new_string = " ".join(clean[1:])
            cleaned_labelsr.append(new_string.strip())

        date_submitted_label = cleaned_labelsr[0]
        closed_date_label = cleaned_labelsr[1]
        final_disposition_label = cleaned_labelsr[2]

        # See if we could grab the date submitted, save it

        if date_submitted_label:
            info_list.append(date_submitted_label)
        else:
            info_list.append("not found")

        # See if we could grab the closed date, save it

        if closed_date_label:
            info_list.append(closed_date_label)
        else:
            info_list.append("not found")

        # See if we could grab final disposition label, save it
        if final_disposition_label:
            info_list.append(final_disposition_label)
        else:
            info_list.append("not found")

        # Grab the description
        description = (soup.find("div", {"class": "quasiTextarea"})).text

        # See if we could grab the description, save it

        if description:
            description_cleaned = description.strip()
            info_list.append(description_cleaned)
        else: 
            info_list.append("not found")


        with open("2014-results.csv", "a") as output_file:
            wr = csv.writer(output_file)
            wr.writerow(info_list)

        time.sleep(0.01)

    except Exception as e:

        error_counter += 1 
        print(error_counter, " | ", url, file=errors)

        print("The error occured at row ", error_counter, "of captured items in errors.txt")
        print(e)
        print("___________________________________________")


errors.close()
