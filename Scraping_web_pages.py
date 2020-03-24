from lxml import html
import requests
import pandas as pd

page = requests.get('http://econpy.pythonanywhere.com/ex/001.html')
tree = html.fromstring(page.content)

buyers = tree.xpath('//div[@title="buyer-name"]/text()')
prices = tree.xpath('//span[@class="item-price"]/text()')

a = {'Buyers': buyers}
b = {'Prices': prices}
d = pd.DataFrame({**a,**b})

d["Prices"] = d["Prices"].str.replace('$', '')
d["Prices"] = pd.to_numeric(d["Prices"])
#promedio = d["Prices"].mean()
#print(d)
#print(promedio)




