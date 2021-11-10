import requests
import pandas as pd
from bs4 import BeautifulSoup

# This scrapper was made to retrieve all players from world cup Wikiepdia.


url = "https://en.wikipedia.org/wiki/{}_FIFA_World_Cup_squads"

dfs = []
for year in range(1930, 2019):
    #print(year)
    soup = BeautifulSoup(requests.get(url.format(year)).content, "html.parser")

    tables = soup.find_all(
        lambda tag: tag.name == "table"
        and tag.select_one('th:-soup-contains("Pos.")'))

    for table in tables:
        for tag in table.select('[style="display:none"]'):
            tag.extract()
        df = pd.read_html(str(table))[0]
        df["Year"] = year
        df["Country"] = table.find_previous(["h3", "h2"]).span.text
        dfs.append(df)

df = pd.concat(dfs)
print(df)
#df.to_csv("data.csv", index=False)