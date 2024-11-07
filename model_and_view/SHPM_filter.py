import os
import numpy as np
from scipy.signal import savgol_filter
import matplotlib.pyplot as plt
from matplotlib import cm


def smooth_SHPM_output(
    input_path, output_dir, file_name, lines_affected=None, dy=None, dx=None
):
    """Smooth SHPM data: electronic noise mitigation"""

    # Ensures output folder exists
    os.makedirs(output_dir, exist_ok=True)

    # define params
    savgol_param = 26

    # Read hall scan output
    f = open(input_path, "r")  # r stand for reading only
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
    m = np.zeros((dy, dx))
    for row in rows:
        if row == "L":
            i += 1
            j = 0
        else:
            m[i, j] = row
            j += 1

    if lines_affected is None:
        lines_affected = dy

    print(dx, dy, lines_affected)

    # Filter
    mp = m.copy()
    for i in range(0, lines_affected):
        mp[i, :] = savgol_filter(m[i, :], dx // savgol_param + 1, 3)

    # Plot 3D map of Voltage Signal
    Y = np.linspace(1, dy, dy)
    X = np.linspace(1, dx, dx)
    X, Y = np.meshgrid(X, Y)
    fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
    ax.plot_surface(X, Y, m, cmap=cm.coolwarm)
    output_path = os.path.join(output_dir, "3D map of Voltage Signal.png")
    fig.savefig(output_path, bbox_inches="tight")
    plt.close(fig)  # close the figure window

    # Plot some smoothing cross-sections to check nothing weird is happening
    for line in range(0, lines_affected, lines_affected // 5):
        fig = plt.figure(line)
        plt.plot(
            np.linspace(1, dx, dx),
            m[line, :],
            "r-",
            np.linspace(1, dx, dx),
            mp[line, :],
            "b--",
        )
        output_path = os.path.join(output_dir, f"Smoothed_line_{line}.png")
        fig.savefig(output_path, bbox_inches="tight")
        plt.close(fig)  # close the figure window

    # Create new csv with filtered data
    output_path = os.path.join(output_dir, file_name + ".csv")
    with open(output_path, "w") as g:
        g.write("P\n")
        for i in range(dy):
            g.write("L\n")
            for j in range(dx):
                g.write("{:.6f}\n".format(mp[i, j]))
