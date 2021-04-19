import tkinter as tk
import matlab.engine


class MainInterface:
    def __init__(self):
        eng = matlab.engine.start_matlab()
        eng.hello_world(nargout=0)
        eng.quit()
        self.main_window = tk.Tk()
        self.main_window.title("Hall measurement routine")
        self.main_window.mainloop()
