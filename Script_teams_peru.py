import pandas as pd
from urllib.parse import quote

# URL de la página
url = "https://es.wikipedia.org/wiki/Anexo:Clubes_de_fútbol_del_Perú"

# Codificar la URL
url_codificada = quote(url, safe=':/')

try:
    tablas = pd.read_html(url_codificada)
except Exception as e:
    print(f"Ocurrió un error: {e}")

clean_tables :list[pd.DataFrame] = []
for table in tablas:
    tag = list(table.columns)[0]
    if tag not in ('Equipo', 'Club'):
        region = tag
    if any(item in ['Equipo', 'Ciudad', 'Fundación', 'Estadio', 'Liga'] for item in list(table.columns)):
        print(f'Exportando tabla: {region}')
        table['region'] = region
        clean_tables.append(table)
        table.to_csv(f"C:\\Users\\JuanCarlosSaraviaDra\\Downloads\\table_{region}.csv", index=False)
