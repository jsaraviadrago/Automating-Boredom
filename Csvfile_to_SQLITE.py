import pandas as pd
import sqlite3 as sq3

conn = sq3.connect('Gareca_historico.sqlite')
cur = conn.cursor()

cur.execute('DROP TABLE IF EXISTS mateposible_info')

cur.execute('CREATE TABLE mateposible_info (Torneo nvarchar(50),'
               'SEDE nvarchar(50), ANHO int,'
               'Peru_pases_tot int, Goles_Peru int)')

data_mp = pd.read_csv("/Users/home/Documents/Documentos/Mate Posible/Matematicamente posible 2018/BD_Oficial_Gareca.csv")
data_mp = pd.DataFrame(data_mp, columns= ['Torneo','ANHO',
                                          'SEDE', 'Peru_pases_tot','Goles_Peru'])

#print(data_mp)
data_mp.to_sql('mateposible_info', conn, if_exists='replace', index=True)

#cur.execute('''SELECT * mateposible_info''')

for row in cur.fetchall():
    print(row)

conn.commit()
conn.close()