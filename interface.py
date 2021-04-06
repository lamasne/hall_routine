import tkinter as tk
import matlab.engine


class MainInterface:
    def __init__(self):
        print('starting matlab engine')
        eng = matlab.engine.start_matlab()
        print('matlab engine started')
        eng.hello_world('PowerOx_5cm_2021_3_31_16_52_', nargout=0)
        eng.quit()
        self.main_window = tk.Tk()
        self.main_window.title("Hall routine")
        self.main_window.mainloop()