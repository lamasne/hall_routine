import os 

sample_name ='SOx(APC)_3cm_bent_16mm_2022_4_11_14_30'

# input_path = os.path.join(r'H:\Mon Drive\PhD\EXPERIMENTS\Hall_routine\inputs\2nd_RADES_cavity_prepa\using small magnet')
input_path = os.path.join(r'H:\Mon Drive\PhD\EXPERIMENTS\Hall_routine\inputs')

# output_path = os.path.join(r'H:\Mon Drive\PhD\EXPERIMENTS\Hall_routine\outputs\2022-04-05 - Half pipes', sample_name)
output_path = os.path.join(r'H:\Mon Drive\PhD\EXPERIMENTS\Hall_routine\outputs', sample_name)

GV = 76.5 # factor de conversio: Gauss per Volt -- 90 GV previously, 83.1, 80.9, 76.5 (from 22-04-22 - 81.7 calculated)
amplecinta = 12e-3 # ample aproximat de la cinta, pot tenir marge d'error de l'ordre del 10-20%
# dx = 5e-4 # pas en X (entre files) de la sonda
# dy = 2e-4 # pas en Y (dins de cada fila) de la sonda
delta_x = 85 # pas en X (entre files) de la sonda
delta_y = 26 # pas en Y (dins de cada fila) de la sonda


pas = 20

ht = 0.3e-3 # alc,ada de mesura

sample_thickness = 3e-6 #SuperOx 3e-6 , superpower:  1.35e-6, Theva 2.8e-6, Fujikura (FESC) 2.5e-6