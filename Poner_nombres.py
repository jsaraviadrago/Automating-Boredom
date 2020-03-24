file = open("Nombres_variables.txt", "w+")
lista = []
print('Hola! Vamos a nombrar cosas')

x = input('Que cosa quieres nombrar\n')
y = input('Con que lo quieres separar\n')
n = input('Cantidad de filas\n')
n = int(n)

for i in range(1,n):
    z = (x + str(i).ljust(1) + y)
    file.write(z)
file.close()
