import numpy as np
from scipy.signal import savgol_filter
import matplotlib.pyplot as plt
from matplotlib import cm


def smooth_SHPM_output(input_path, output_path, lines_affected=None, dy=None, dx=None):
    # Smooth SHPM data
    #define params
    savgol_param = 26

    # Read hall scan output
    f = open(input_path, "r") # r stand for reading only
    rows = [line.strip() for line in f.readlines()][2:]
    f.close()
    
    # Get number of lines and colums
    if dy is None:
        dy = 1
        for row in rows:
            if row == "L":
                dy += 1
    if dx is None:
        dx = 0
        for row in rows:
            if row == "L":
                break
            else:
                dx += 1

    # Build array with data
    i = 0
    j = 0
    m = np.zeros((dy,dx))
    for row in rows:
        if row == "L":
            i += 1
            j = 0
        else:
            m[i,j] = row
            j += 1

    if lines_affected is None:
        lines_affected = dy

    print(dx, dy, lines_affected)

    # Filter
    mp = m.copy()
    for i in range(0, lines_affected):
        mp[i,:] = savgol_filter(m[i,:], dx//savgol_param, 3)

    # Ploting
    Y = np.linspace(1, dy, dy)    
    X = np.linspace(1, dx, dx)
    X, Y = np.meshgrid(X, Y)
    fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
    surf = ax.plot_surface(X, Y, m, cmap=cm.coolwarm)
    for line in range(0,lines_affected,lines_affected//5):
        plt.figure(line) 
        plt.plot(np.linspace(1, dx, dx), m[line,:], 'r--', np.linspace(1, dx, dx), mp[line,:], 'b--')
        plt.show()

    # Create new csv with filtered data
    g = open(output_path, "w")
    g.write('P\n')
    for i in range(dy):
        g.write('L\n')
        for j in range(dx):
            g.write("{:.6f}\n".format(mp[i,j]))
    g.close()

