plata = input('Poner aca el importe mensual\n')
plata = float(plata)
mes = float(12)
gratificacion = float(2)
bono = input('Cuantos bonos tienes\n')
bono = float(bono)

segplata = input('Poner la cantidad de trabajos adicionales\n')
segplata = float(segplata)

if segplata != 0:
    platados = input('Poner segundo importe mensual\n')
    platados = float(platados)
    respuesta = ((plata+platados)*(mes+bono+gratificacion))/14
else:
   respuesta = (plata*(mes+bono+gratificacion))/14

print(respuesta)

