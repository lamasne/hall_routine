import customtkinter as ctk
import tkinter as tk
# from tkinter import ttk
from abc import ABC, abstractmethod # to build Abstract classes
import math


class InterfaceElement(ABC):
    @abstractmethod
    def __init__(self, panel, name, default, row=0):
        self.panel = panel
        self.name = name
        self.val = default
        # self.row = len(elements)
        self.row = row
        self.panel.elements[name] = self
    
    # @abstractmethod
    # def assign_var(self, value):
    #     pass

    def get_value(self):
        return self.val


class ButtonEntry(InterfaceElement):
    def __init__(self, panel, name, default, row=0, c=0):
        super().__init__(panel, name, default, row)
        root = self.panel.window
        default = str(default)

        # Label
        self.lb = ctk.CTkLabel(root, text=self.panel.view.param_labels[self.name])
        self.lb.grid(column=c, row=self.row, sticky="e", padx=10)

        # Entry
        if len(default) < 10:
            self.entry = ctk.CTkEntry(root, width=80)
            column_span = 1
        else:
            self.entry = ctk.CTkEntry(root, width=400)
            column_span = 3
        self.entry.grid(column=c+1, row=self.row, columnspan = column_span, sticky="ew")
        self.entry.insert(0, default)

        # Confirm button
        self.bt = ctk.CTkButton(root, text="Confirm", width=40, command=lambda: self.assign_var(self.entry.get()))
        self.bt.grid(column=c+1+column_span, row=self.row, sticky="w")

    def assign_var(self, value):
        self.val = value
        # Make sure the text of the entries represent their actual values 
        try:
            if (self.entry.get() != self.val):
                self.entry.delete(0,ctk.END)
                self.entry.insert(0, self.val)
        except AttributeError:
            print("Tried to change an element from the interface that doesn't have any entry attribute")

        print(self.name + ' set to ' + self.val)
        self.panel.view.update(self.name)

    def destroy(self):
        # remove every tk element
        self.lb.destroy()
        self.entry.destroy()
        self.bt.destroy()

class Checkbox(InterfaceElement):
    
    def __init__(self, panel, name, default, row=0, col=0, padx=10):
        super().__init__(panel, name, default, row)
        root = self.panel.window
        self.val = tk.IntVar(value=default)

        self.bt = ctk.CTkCheckBox(root, 
            text=self.panel.view.param_labels[self.name], 
            variable=self.val,
            onvalue=1,
            offvalue=0,
            command=lambda : print(self.name + ' set to ' + str(bool(self.val.get())))
        )

        self.bt.grid(column=col, row=self.row, padx=padx)

class Switch(InterfaceElement):

    def __init__(self, panel, var_name, text, default, row=0, col=0):
        super().__init__(panel, var_name, default, row)
        root = self.panel.window
        self.val = ctk.BooleanVar(value=default)  # Default to Dark mode
        self.bt = ctk.CTkSwitch(root, text=text, variable=self.val, command=self.panel.toggle_dark_mode)
        # self.elements["mode_switch"] = (switch_var, switch)
        self.bt.grid(column=col, row=row)
