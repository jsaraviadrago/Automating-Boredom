from lxml import html
import requests
import pandas as pd

page = requests.get('https://es.wikipedia.org/wiki/Clasificación_de_Conmebol_para_la_Copa_Mundial_de_Fútbol_de_2018')
#tree = html.fromstring(page.content)
print(page.content)

#buyers = tree.xpath('//div[@title="buyer-name"]/text()')
#prices = tree.xpath('//span[@class="item-price"]/text()')

#a = {'Buyers': buyers}
#b = {'Prices': prices}
#d = pd.DataFrame({**a,**b})

#d["Prices"] = d["Prices"].str.replace('$', '')
#d["Prices"] = pd.to_numeric(d["Prices"])
#promedio = d["Prices"].mean()
#print(d)




