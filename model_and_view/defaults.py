sample_name = 'PowerOx_5cm_Neil_2021_3_31_16_52_'

input_path = r'C:\Users\nlamas\Downloads'
output_path = r'C:\Users\nlamas\Desktop\Actual_work\Hall_routine'

dx = 5e-4 # pas en X (entre files) de la sonda
dy = 5e-6 # pas en Y (dins de cada fila) de la sonda
ht = 0.3e-3 # alc,ada de mesura
GV = 97. # factor de conversio: Gauss per Volt % 14.23 For Roxana  % 70.93 for Pedro
amplecinta = 22e-3 # ample aproximat de la cinta, pot tenir marge d'error de l'ordre del 10-20%

m=300 # 400 number of measurements in every row (columns)
n=226 # 35 number of rows