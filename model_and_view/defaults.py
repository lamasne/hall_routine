import os 


sample_name ='Theva_delam_no_solder_bent_11mm_2021_7_9_14_24'

# input_path = r'C:\Users\nlamas\Downloads'
input_path = os.path.join(r'C:\Users\nlamas\Desktop\Actual_work\Hall_routine\inputs')
# output_path = os.path.join(r'C:\Users\nlamas\Desktop\Actual_work\Hall_routine\outputs', sample_name)
output_path = os.path.join(r'C:\Users\nlamas\Desktop\Actual_work\Hall_routine\outputs', sample_name)


GV = 83.1 # factor de conversio: Gauss per Volt -- 90 GV previously
amplecinta = 12e-3 # ample aproximat de la cinta, pot tenir marge d'error de l'ordre del 10-20%
# dx = 5e-4 # pas en X (entre files) de la sonda
# dy = 2e-4 # pas en Y (dins de cada fila) de la sonda
delta_x = 62 # pas en X (entre files) de la sonda
delta_y = 34 # pas en Y (dins de cada fila) de la sonda


pas = 20

ht = 0.3e-3 # alc,ada de mesura

sample_thickness = 2.5e-6 #SuperOx 3e-6 , superpower:  1.35e-6, Theva 2.8e-6, Fujikura (FESC) 2.5e-6