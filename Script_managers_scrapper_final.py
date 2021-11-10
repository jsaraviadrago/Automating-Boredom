import requests
import pandas as pd
from bs4 import BeautifulSoup


#Scrape 1 table in managers

url = "https://en.m.wikipedia.org/wiki/List_of_managers_at_the_FIFA_World_Cup"

soup = BeautifulSoup(requests.get(url).content, "html.parser")

tables = soup.find_all(
    lambda tag: tag.name == "table"
            and tag.select_one('th:-soup-contains("Year","Manager")'))

for table in tables:
    for tag in table.select('[style="display:none"]'):
        tag.extract()
    df = pd.read_html(str(table))[0]

#print(df)
#df.to_csv("/Users/home/Downloads/data_results_manager.csv", index=False)

tables2 = soup.find_all(
    lambda tag2: tag2.name == "table"
        and tag2.select_one('th:-soup-contains("Managers")'))

for table2 in tables2:
    for tag2 in table2.select('[style="display:none"]'):
        tag2.extract()
    df2 = pd.read_html(str(table2))[0]

#df2.to_csv("/Users/home/Downloads/data_managers_year.csv", index=False)
