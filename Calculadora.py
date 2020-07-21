

plata = input('Poner aca el importe mensual\n')
try:
    plata = float(plata)
except ValueError:
    print("Tienes que poner en numero\n")
    plata = input('Poner aca el importe mensual\n')
    plata = float(plata)
else:
    plata = float(plata)

mes = float(12)
gratificacion = float(2)
bono = input('Poner número de bonos\n')
try:
    bono = float(bono)
except ValueError:
    print("Tienes que poner un numero")
    bono = input('Poner número de bonos\n')
    bono = float(bono)
else:
    bono = float(bono)

respuesta = (plata*(mes+bono+gratificacion))/12

print(respuesta)

