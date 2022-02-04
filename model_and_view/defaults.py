import os 

sample_name ='Theva_normal_5cm_2_2021_12_1_16_53'

input_path = os.path.join(r'G:\My Drive\PhD\EXPERIMENTS\Hall_routine\inputs')
output_path = os.path.join(r'G:\My Drive\PhD\EXPERIMENTS\Hall_routine\outputs', sample_name)


GV = 80.9 # factor de conversio: Gauss per Volt -- 90 GV previously, 83.1 or 80.9
amplecinta = 12e-3 # ample aproximat de la cinta, pot tenir marge d'error de l'ordre del 10-20%
# dx = 5e-4 # pas en X (entre files) de la sonda
# dy = 2e-4 # pas en Y (dins de cada fila) de la sonda
delta_x = 74 # pas en X (entre files) de la sonda
delta_y = 26 # pas en Y (dins de cada fila) de la sonda


pas = 20

ht = 0.3e-3 # alc,ada de mesura

sample_thickness = 2.8e-6 #SuperOx 3e-6 , superpower:  1.35e-6, Theva 2.8e-6, Fujikura (FESC) 2.5e-6