# hall_routine
Data processing post hall measurements

Requires: 
- Python 3.4 or higher versions
- Matlab2015a (or higher versions if Python version is at least 3.7)
- VSCode (Python 3.4 not supported in PyCharm) 
- Git Bash


Will be updated to Matlab2024 - Python3.7

How to use:

1) Download code:
   - Make sure you have downloaded all the software needed in the right versions (I recommend Matlab2021 or later - Python3.7 or later - VSCode - Git Bash)
   - Open a Git Bash terminal
   - Within the Git Bash terminal, move into the directory in which you want to download the software (e.g. "cd C:\Users\XXX\Desktop\workspace")
   - Enter following command: "git clone https://github.com/lamasne/hall_routine.git"

2) Activate matlab use from python:
   - Open a command prompt as admin and enter:
     
     "cd C:_matlabroot_\extern\engines\python" 
     
     (where _matlabroot_ is the path to matlab on your machine, e.g. "C:\Program Files\MATLAB\R2022a\extern\engines\python")

   - Then, enter: 

     "_pythonroot_ setup.py install" 
     
     (where _pythonroot_ is the path to python on your machine, e.g. "C:\Users\Lamas\AppData\Local\Programs\Python\Python37\python.exe setup.py install")

3) Run code:
   - Open a code editor (e.g. Visual Studio code - might need to download it first)
   - Within your code editor, open the folder hall_routine
   - Press "run" (play button)

4) Once it runs, you might want to change the values of input and output paths in model_and_view/defaults.py, so that the interface always opens with your hall probe folder suggested as input/output path

Debugging:
1) Check that you selected the right version of Python in your code editor
   - From Pycharm settings Python interpreter: inherit package from sites-package
   - From VS code, https://code.visualstudio.com/docs/python/python-tutorial

Programmer note: to use matlab, use matlab.engine in the python code
