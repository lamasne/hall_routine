import os

sample_name = "FESC_intact_2cm_substrate_up_2023_5_12_15_54"

input_path = os.path.join(r"H:\My Drive\PhD\EXPERIMENTS\Hall_routine\inputs\2023")
# input_path = os.path.join(r'H:\My Drive\PhD\EXPERIMENTS\Hall_routine\inputs')

# output_path = os.path.join(r'H:\Mon Drive\PhD\EXPERIMENTS\Hall_routine\outputs\2022-04-05 - Half pipes', sample_name)
output_path = os.path.join(
    r"H:\My Drive\PhD\EXPERIMENTS\Hall_routine\outputs", sample_name
)

GV = 513.6

# GV = 76.5 # factor de conversio: Gauss per Volt -- 90 GV previously, 83.1, 80.9, 76.5 (from 22-04-22 - 81.7 calculated)
amplecinta = (
    12e-3  # ample aproximat de la cinta, pot tenir marge d'error de l'ordre del 10-20%
)
GV = 513.6
# GV = 76.5 # factor de conversio: Gauss per Volt -- 90 GV previously, 83.1, 80.9, 76.5 (from 22-04-22 - 81.7 calculated)
amplecinta = (
    12e-3  # ample aproximat de la cinta, pot tenir marge d'error de l'ordre del 10-20%
)
# dx = 5e-4 # pas en X (entre files) de la sonda
# dy = 2e-4 # pas en Y (dins de cada fila) de la sonda
delta_x = 38  # pas en X (entre files) de la sonda
delta_y = 26  # 26 - pas en Y (dins de cada fila) de la sonda


pas = 20

ht = 0.388e-3  # distance probe to SC layer: Al foil + sensor internal wall = 316um; Cu + Ag = 22um

sample_thickness = (
    2.5e-6  # SuperOx 3e-61 , superpower:  1.35e-6, Theva 2.8e-6, Fujikura (FESC) 2.5e-6
)

filter_bool = 1  # 0
