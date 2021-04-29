import os 


sample_name ='Theva_5cm_normal_tape_2021_4_16_17_18'

# input_path = r'C:\Users\nlamas\Downloads'
input_path = os.path.join(r'C:\Users\nlamas\Desktop\Actual_work\Hall_routine\inputs')
# output_path = os.path.join(r'C:\Users\nlamas\Desktop\Actual_work\Hall_routine\outputs', sample_name)
output_path = os.path.join(r'C:\Users\nlamas\Desktop\Actual_work\Hall_routine\outputs', sample_name + '_2')


GV = 97. # factor de conversio: Gauss per Volt % 14.23 For Roxana  % 70.93 for Pedro
amplecinta = 12e-3 # ample aproximat de la cinta, pot tenir marge d'error de l'ordre del 10-20%
# dx = 5e-4 # pas en X (entre files) de la sonda
# dy = 2e-4 # pas en Y (dins de cada fila) de la sonda
# ht = 0.3e-3 # alc,ada de mesura
dx = 2e-4 # pas en X (entre files) de la sonda
dy = 5e-6 # pas en Y (dins de cada fila) de la sonda
ht = 0.3e-3 # alc,ada de mesura

m=351 # number of measurements in every row (columns)
n=5600 # number of rows (number of y lines)

sample_thickness = 3e-6 #Theva and SuperOx 3e-6 , superpower:  1.35e-6