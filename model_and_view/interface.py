import customtkinter as ctk
# import tkinter as tk
# import tkinter.font as font
import matlab.engine
import model_and_view.defaults as defaults_settings
from model_and_view.view_elements import *
from time import sleep
import os
from model_and_view.SHPM_filter import smooth_SHPM_output

# ctk.set_appearance_mode("dark")  # Modes: system (default), light, dark
ctk.set_default_color_theme("dark-blue")

class MainInterface:
    def __init__(self):
        self.param_labels = {
            "sample_name": "Sample name",
            "input_path": "Input path",
            "output_path": "Output path",
            "delta_x": "Length [mm]",
            "delta_y": "Width [mm]",
            "ht": "Height",
            "GV": "Gauss/Volt conv. factor",
            "amplecinta": "Tape width [m]",
            "sample_thickness": "Sample thick. [m]",
            "pas": "Step in X",
            "filter_bool": "Filter SHPM output?",
        }
        self.main_window = ctk.CTk()
        # self.main_window = tk.Tk()
        self.main_window.title("SHPM interface")
        self.panels = []
        self.main_panel = MainPanel(self, self.main_window)
        self.update()
        self.main_window.mainloop()

    def update(self, comment=""):
        # update output path according to sample name
        if comment == "sample_name":
            self.main_panel.update_output_path()


# Import view only for notify (notify(view) should be replaced by notify() and the view should catch it)?
class MainPanel():
    def __init__(self, view, window):
        self.view = view
        self.elements = {}
        self.window = window
        
        self.bt_pos = [
            "title",
            "sample_name",
            "input_path",
            "output_path",
            "delta_x",
            "delta_y",
            "amplecinta",
            "sample_thickness",
            "pas",
            "ht",
            "GV",
            "check",
            "go",
        ]
        self.output_format = [
            "sample_name",
            "input_path",
            "output_path",
            "delta_x",
            "delta_y",
            "amplecinta",
            "sample_thickness",
            "pas",
            "ht",
            "GV",
        ]

        # Create content
        # tk.Label(self.window, text="Parameters", font="Helvetica 16 bold italic").grid(
        #     column=0, row=self.bt_pos.index("title")
        # )

        # ctk.CTkLabel(self.window, text="Parameters", font=ctk.CTkFont(family="Helvetica", size=20, weight="bold", slant="italic")).grid(
        #     column=0, row=self.bt_pos.index("title")
        # )

        # ctk.CTkLabel(self.window, text="Parameters", font=ctk.CTkFont(size=24, weight="bold")).grid(
        #     column=0, row=self.bt_pos.index("title")
        # )

        ButtonEntry(
            self,
            "sample_name",
            str(defaults_settings.sample_name),
            self.bt_pos.index("sample_name"),
        )
        ButtonEntry(
            self,
            "input_path",
            str(defaults_settings.input_path),
            self.bt_pos.index("input_path"),
        )
        ButtonEntry(
            self,
            "output_path",
            str(defaults_settings.output_path),
            self.bt_pos.index("output_path"),
        )
        ButtonEntry(
            self,
            "delta_x",
            str(defaults_settings.delta_x),
            self.bt_pos.index("delta_x"),
        )
        ButtonEntry(
            self,
            "delta_y",
            str(defaults_settings.delta_y),
            self.bt_pos.index("delta_y"),
        )
        ButtonEntry(
            self,
            "amplecinta",
            str(defaults_settings.amplecinta),
            self.bt_pos.index("amplecinta"),
        )
        ButtonEntry(
            self,
            "sample_thickness",
            str(defaults_settings.sample_thickness),
            self.bt_pos.index("sample_thickness"),
        )
        ButtonEntry(self, "ht", str(defaults_settings.ht), self.bt_pos.index("ht"))
        ButtonEntry(self, "pas", str(defaults_settings.pas), self.bt_pos.index("pas"))
        ButtonEntry(self, "GV", str(defaults_settings.GV), self.bt_pos.index("GV"))

        # Switch widget
        Switch(self, "mode_switch", "Dark mode", default=False, row=self.bt_pos.index("go")-1, col=0)
        
        # Run button + filter checkbox
        Checkbox(
            self,
            "filter_bool",
            defaults_settings.filter_bool,
            row=self.bt_pos.index("go")-1,
            col=3,
            padx=10,
        )

        self.elements["go_btn"] = ctk.CTkButton(
            self.window,
            font=("Helvetica", 30),
            text="Run!",
            command=lambda: (self.go()),
        )
        self.elements["go_btn"].grid(column=4, row=self.bt_pos.index("go")-1)

    # Function to toggle theme
    def toggle_dark_mode(self):
        ctk.set_appearance_mode("Dark") if self.elements["mode_switch"].val.get() else ctk.set_appearance_mode("Light")
        
    # Function to put in another file and take run_params as argument
    def go(self):

        # Smooth SHPM output
        if self.elements["filter_bool"].val.get():
            print("The SHPM output is going to be smoothed")
            input_path = os.path.join(
                self.elements["input_path"].val,
                self.elements["sample_name"].val + ".csv",
            )
            filter_output_dir = os.path.join(
                self.elements["output_path"].val,
                "filtered",
            )
            new_file_name = "smoothed_" + self.elements["sample_name"].val
            smooth_SHPM_output(input_path, filter_output_dir, new_file_name)
            self.elements["input_path"].val = filter_output_dir
            self.elements["sample_name"].val = new_file_name

        run_params = tuple(self.elem_to_run_param(name) for name in self.output_format)
        print("Parameters of the run: ", end="")
        print(*run_params)

        # Write parameters to a readme
        output_path = self.elem_to_run_param("output_path")
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        print("Created directory: " + str(output_path))
        with open(os.path.join(output_path, "readme.txt"), "w") as f:
            for elem in run_params:
                f.write(str(elem) + "\n")

        # Matlab script
        print("Starting matlab engine")
        eng = matlab.engine.start_matlab()
        print("Matlab engine started")

        # Add path so that matlab knows where to find the .m files
        # matlab_fct_path = os.path.join(os.path.abspath(os.getcwd()), "matlab_functions")
        matlab_fct_path = os.path.abspath(
            os.path.join(os.path.dirname(__file__), "..", "matlab_functions")
        )

        eng.addpath(matlab_fct_path)

        eng.init_global(*run_params, nargout=0)
        eng.Hall2B(nargout=0)
        eng.SSA_filter(nargout=0)
        eng.fourier(nargout=0)

        print("Enter m0:")
        m0 = float(input())
        print("Enter mf:")
        mf = float(input())
        print("Enter n0:")
        n0 = float(input())
        print("Enter nf:")
        nf = float(input())

        eng.fourier_part(m0, mf, n0, nf, nargout=0)

        eng.quit()

    def elem_to_run_param(self, name):
        if name not in self.elements:
            return None
        else:
            val = self.elements[name].val

        if val is None:
            return None
        else:
            if name in ["sample_name", "input_path", "output_path"]:
                return val
            elif name in [
                "delta_x",
                "delta_y",
                "ht",
                "GV",
                "amplecinta",
                "sample_thickness",
                "pas",
            ]:
                return float(val)
            else:
                raise KeyError

    # If output path does not contain the sample name, it changes the last directory of the path by the sample name
    def update_output_path(self):
        sample_name = str(self.get_element("sample_name").get_value())
        output_path = str(self.get_element("output_path").get_value())

        if sample_name not in output_path:
            separation_characters = ["//", "/", "\\"]
            splitted_output_path = []
            i = -1
            while len(splitted_output_path) < 2:
                i += 1
                if i >= len(separation_characters):
                    print("Output path could not be updated")
                    return -1
                splitted_output_path = output_path.split(separation_characters[i])
            splitted_output_path[-1] = sample_name
            self.get_element("output_path").assign_var(
                separation_characters[i].join(splitted_output_path)
            )

    def get_element(self, name):
        return self.elements[name]
