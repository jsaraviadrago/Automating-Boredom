import requests
import pandas as pd
from bs4 import BeautifulSoup
from io import StringIO

# This scrapper was made to retrieve all teams in peru from Wikiepdia.

url = "https://es.wikipedia.org/wiki/Anexo:Clubes_de_fútbol_del_Perú"

dfs = []
soup = BeautifulSoup(requests.get(url).content, "html.parser")

tables = soup.find_all(
    lambda tag: tag.name == "table"
        and tag.select_one('th:-soup-contains("Equipo", "Ciudad", "Fundación", "Estadio", "Liga")'))

for table in tables:
    for tag in table.select('[style="display:none"]'):
        tag.extract()
    df = pd.read_html(StringIO(str(table)))[0]
    df['Region'] = table.find_previous(["h3","h2"]).span.text
    dfs.append(df)

df = pd.concat(dfs)
print(dfs)


#df.to_csv("/Users/home/Downloads/data_results_manager.csv", index=False)

