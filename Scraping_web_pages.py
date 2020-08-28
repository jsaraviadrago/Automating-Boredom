from bs4 import BeautifulSoup
from urllib.request import urlopen
import ssl

ssl._create_default_https_context = ssl._create_unverified_context

html = urlopen('https://en.wikipedia.org/wiki/2022_FIFA_World_Cup_qualification_(CONMEBOL)')
bs = BeautifulSoup(html.read(), 'lxml')

nameList = bs.findAll('span', {'class':'green'})
for name in nameList:
    print(name.get_text())

prueba = bs.find_all(['h1','h2','h3','h4'])




