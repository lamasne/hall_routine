import os

# Name of the input file (without extension)
sample_name = "FF_PSFC_free-standing_delam_25mm_1_2023_11_13_16_28"

# Path of the input file
commonpath = os.path.join(r"G:\My Drive\PhD\EXPERIMENTS\Hall_routine")
input_path = os.path.join(commonpath, r"inputs\2023")

# Path of the output file
# output_path = os.path.join(commonpath, "outputs", sample_name)
output_path = os.path.join(commonpath, r"outputs\tests")

# Gauss per Volt conversion factor:  previously: 76.5, 90, 83.1, 80.9, 76.5
GV = 513.6

# Width of the tape (in m) - typically 12e-3
amplecinta = 12e-3
# Length of the scan (in mm) - (Y in hall scan)
delta_x = 41
# Width of the scan (in mm) - (X in hall scan) - typically 26 = 12 + 7*2
delta_y = 26

# Select only 1 out of "pas" values of scanning in x direction - Leave at 20 unless you know what you're doing
pas = 20

# Distance probe to SC layer: sensor epoxy wall = 300um; Al foil = 16um ; Cu + Ag = 22um
ht = 316e-6
# ht = 388e-6

# Sample thickness: SuperOx 3e-6, superpower:  1.35e-6, Theva 2.8e-6, Fujikura (FESC) 2.5e-6
sample_thickness = 2.5e-6

# Activate savgol filtering of the input signal?
filter_bool = 1
