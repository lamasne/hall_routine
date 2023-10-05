import tkinter as tk
import tkinter.font as font
import matlab.engine
import model_and_view.defaults as defaults_settings
from model_and_view.view_elements import *
from time import sleep
import os


class MainInterface:
    def __init__(self):
        self.param_labels = {
            "sample_name": "Sample name",
            "input_path": "Input path",
            "output_path": "Output path",
            "delta_x": "length [mm]",
            "delta_y": "width [mm]",
            "ht": "ht",
            "GV": "GV",
            "amplecinta": "amplecinta [m]",
            "sample_thickness": "Sample thick. [m]",
            "pas": "pas",
        }
        self.main_window = tk.Tk()
        self.main_window.title("Hall routine")
        self.panels = []
        self.main_panel = MainPanel(self, self.main_window)
        self.update()
        self.main_window.mainloop()

    def update(self, comment=""):
        # update output path according to sample name
        if comment == "sample_name":
            self.main_panel.update_output_path()

        # Create or destroy sub-parameters entries depending on the configuration
        # self.main_panel.single_sub_param("fitting", 2, "init_params", init_params)
        # self.main_panel.single_sub_param("smooth", True, "smooth_params", smooth_params)
        # self.main_panel.single_sub_param("normalize", True, "Ic0", Ic0)
        # self.main_panel.multiple_sub_param("I_2_J", True, ["manuf_width", "exp_width", "thickness"], [manuf_width, exp_width, thickness], 'Parameters for conversion to Jc')

    def create_panel(self, title):
        window = tk.Toplevel()
        window.title(title)
        panel = Panel(self, window)
        self.panels.append(panel)
        return panel

    def remove_panel(self, panel):
        panel.window.destroy()
        self.panels.remove(panel)

    def get_panels(self):
        return self.panels


# Import view only for notify (notify(view) should be replaced by notify() and the view should catch it)?
class Panel:
    def __init__(self, view, window):
        self.view = view
        self.elements = {}
        self.window = window

    def destroy_elem(self, name):
        if name in self.elements:
            self.elements[name].destroy()
            del self.elements[name]
        else:
            print(
                "attempt to destroy "
                + name
                + " from panel but it does not exist in elements"
            )


class MainPanel(Panel):
    def __init__(self, view, window):
        Panel.__init__(self, view, window)
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
        tk.Label(self.window, text="Parameters", font="Helvetica 16 bold italic").grid(
            column=0, row=self.bt_pos.index("title")
        )
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

        go = tk.Button(
            self.window,
            font=font.Font(size=30),
            text="Run!",
            command=lambda: (self.go()),
        )
        last_row, last_column = self.window.grid_size()
        go.grid(column=last_column, row=self.bt_pos.index("go"))

    # Function to put in another file and take run_params as argument
    def go(self):
        run_params = tuple(self.elem_to_run_param(name) for name in self.output_format)
        print("Parameters of the run: ", end="")
        print(*run_params)

        # Write parameters to a readme
        tmp = self.elem_to_run_param("output_path")
        if not os.path.exists(tmp):
            os.makedirs(tmp)
            print("Created directory: " + str(tmp))
        readme_path = os.path.join(tmp, "readme.txt")
        f = open(readme_path, "a")  # a for append instead of w for (over)write
        for elem in run_params:
            f.write(str(elem) + "\n")
        f.close()

        # Matlab script
        print("Starting matlab engine")
        eng = matlab.engine.start_matlab()
        print("Matlab engine started")

        # eng.addpath(r'C:\Users\nlamas\workspace\hall_routine\matlab_functions')
        matlab_fct_path = os.path.join(os.path.abspath(os.getcwd()), "matlab_functions")
        print(matlab_fct_path)
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

        f = open(readme_path, "a")
        f.write(f"\nm0:{m0}\nmf:{mf}\nn0:{n0}\nnf:{nf}\n\n")
        f.close()

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

    # Create/destroy sub-parameter entry next to parent parameter
    def single_sub_param(self, parent_name, condition, child_name, default):
        elements = self.elements
        if type(default) != list:
            default = [default]
        # if condition for sub-param to make sense and sub params not yet there --> create
        if (
            self.elem_to_run_param(parent_name) == condition
            and child_name not in elements
        ):
            parent_pos = elements[parent_name].bt.grid_info()
            pos = parent_pos["row"], parent_pos["column"] + 1
            ButtonEntry(
                self, child_name, " ".join([str(elem) for elem in default]), *pos
            )
        # if condition for sub-param does not make sense and it is shown --> destroy
        elif (
            self.elem_to_run_param(parent_name) != condition and child_name in elements
        ):
            self.destroy_elem(child_name)

    # Create/destroy window for multiple sub-parameters
    def multiple_sub_param(self, parent_name, condition, child_names, defaults, title):
        for default in defaults:
            if type(default) != list:
                default = [default]

        # Check if sub_panel already exists
        sub_panel = None
        for panel in self.view.get_panels():
            if panel.window.title() == title:
                sub_panel = panel

        # if condition for sub-params to make sense and not already shown, open window
        if self.elem_to_run_param(parent_name) == condition and sub_panel is None:
            sub_panel = self.view.create_panel(title)
            for i in range(len(child_names)):
                self.elements[child_names[i]] = ButtonEntry(
                    sub_panel, child_names[i], defaults[i], i
                )
            sub_panel.window.mainloop()

        # if condition for sub-params does not make sense and they are shown --> destroy
        elif self.elem_to_run_param(parent_name) != condition and sub_panel is not None:
            for child_name in child_names:
                # destroy every elem from the panel
                sub_panel.destroy_elem(child_name)
            # destroy the window and remove from view's list of panel
            self.view.remove_panel(sub_panel)
