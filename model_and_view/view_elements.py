import tkinter as tk
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

    def assign_var(self, name, panel):
        self.val = self.entry.get()
        print(name + ' set to ' + self.val)
        panel.view.update()

    @abstractmethod
    def destroy(self):
        pass


class ButtonEntry(InterfaceElement):
    def __init__(self, panel, name, default, row=0, c=0):
        super().__init__(panel, name, default, row)

        root = self.panel.window
        default = str(default)
        column_span = math.ceil(len(default)/20)

        # Label
        self.lb = tk.Label(root, text=self.panel.view.param_labels[name])
        self.lb.grid(column=c, row=self.row)

        # Entry
        if len(default) < 10:
            self.entry = tk.Entry(root, width=10)
            self.entry.grid(column=c+1, row=self.row)
        else:
            self.entry = tk.Entry(root, width=int(len(default)))
            self.entry.grid(column=c+1, row=self.row, columnspan=column_span)
        self.entry.insert(0, default)

        # Confirm button
        self.bt = tk.Button(root, text="Confirm", command=lambda: self.assign_var(name, self.panel))
        self.bt.grid(column=c+1+column_span, row=self.row)

    def destroy(self):
        # remove every tk element
        self.lb.destroy()
        self.entry.destroy()
        self.bt.destroy()

