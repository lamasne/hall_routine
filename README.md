# Scanning Hall Probe Microscopy (SHPM): Data Processing Tool

This software processes data from Scanning Hall Probe Microscopy (SHPM) measurements, primarily used for characterizing superconducting coated conductors. I developed it during my PhD in Physics at the Institute of Materials Science of Barcelona (ICMAB-CSIC).

## Objectives

This software streamlines superconducting material (type-II) analysis, enabling researchers to extract meaningful insights from SHPM data quickly and accurately.

## Key Features

- [x] **Computes** the **current density distribution ($J_c$)** using the **Biot-Savart law**  
- [x] **Processes** SHPM data stored in **CSV format**  
- [x] **Cleans** signal noise using a **Savitzky-Golay filter**  
- [x] **Generates** high-quality plots of the **trapped field** and **current density distribution**  
- [x] **Provides** a **Graphical User Interface (GUI)** for ease of use  

## Example Outputs

<img src="doc/images/outputs_SHPM.png" alt="Typical trapped field and critical current density distribution in a coated conductor" height="250">

## Screenshot of the interface

<img src="doc/images/interface.png" alt="GUI Interface" height="300">

## Installation and Setup

### 1) Prerequisites
Ensure you have the following installed:
   - **Python 3.4+** (recommended: Python 3.7+)
   - **MATLAB 2015a+** (must be compatible with Python version (see `https://github.com/mathworks/matlab-engine-for-python`)
   - **MATLAB Statistics Toolbox**
   - **VSCode** (or another IDE)
   - **Git Bash** (for repository cloning)

### 2) Clone the Repository

- Open **Git Bash** terminal.
- Navigate to the desired directory for the project (e.g., `cd C:\Users\XXX\Desktop\workspace`).
- Run the following command:
  ```bash
  git clone https://github.com/lamasne/hall_routine.git
  ```
### 3) Setup your environment
I recommend to work with a **virtual environment**. It ensures dependency isolation and eliminates the need to manually manage package versions. 
Open a PowerShell terminal (e.g., from your IDE) and run:
```bash
python -m venv .venv
```
#### Activate the Virtual Environment
- Select `.\.venv\Scripts\python.exe` as your **Python Interpreter** in your IDE (see [VSCode Python Setup](https://code.visualstudio.com/docs/python/python-tutorial)):
- Activate the environment in Powershell (to set up your shell to use the environment’s Python executable and its site-packages by default.)
```bash
.\.venv\Scripts\Activate
```
If you encounter an error like `cannot be loaded because the execution of scripts is disabled on this system`, open PowerShell as Administrator and run:
```bash
Set-ExecutionPolicy Unrestricted -Force
```
Then, retry the activation command.

#### Install Required Python Packages
If you're using `Python 3.12` and `MATLAB 2024b`, install all dependencies with:
```bash
pip install -r requirements.txt
```
Otherwise, install missing packages manually:
```bash
python -m pip install <package_name>
```
You can identify missing packages by running the application (see the relevant section) and read error messages or checking for `import <package_name>` statements highlighted in yellow in the code.
The only tricky package is matlabengine which enables MATLAB functionality within Python and which version must be specified and tailored to your version of Python and Matlab. To install the MATLAB Engine API, you have two options:

#### Option 1: Install matlabengine via `pip`
Find the compatible version in the [MATLAB Engine GitHub repository](https://github.com/mathworks/matlab-engine-for-python). Then, install it:
Find a compatible version of the MATLAB Engine API and install it with:
```bash
python -m pip install matlabengine==<version>
```
For instance, with `Python3.12` and `Matlab2024b`, use:
```bash
python -m pip install matlabengine==24.2.1
```

#### Option 2: Install from MATLAB’s Built-in Script
To ensure compatibility, install directly from MATLAB:
- Open a command prompt as Administrator.
- Navigate to the Matlab's Python engine directory:
```bash
cd C:<matlabroot>\extern\engines\python
```
Replace `<matlabroot>` with the path to your Matlab installation (e.g., `C:\Program Files\MATLAB\R2022a)`.
- Install the engine for your Python interpreter:
```bash
<pythonroot> setup.py install
   ```
Replace `<pythonroot>` with the path to your Python Executable (e.g., `C:\hall_routine\.venv\Scripts\python.exe`).

## How to use:

### 5) Run the Software
- Open the **hall_routine** directory from VScode (or another IDE).
- Click the Run button (play icon) to execute the script.
- Input the SHPM run parameters in the interface and click on the bottom right button `Run!` to start computation.

### 6) Set Default Paths
To avoid manually selecting directories each time, update `model_and_view/defaults.py` with your preferred input/output paths.

<!--
## Common Issues & Fixes:
### ❌ Incorrect Python version?
- **In PyCharm:** Go to Settings > Project Interpreter and select the correct version.
- **In VSCode:** Set up the correct interpreter using the [VSCode Python Setup](https://code.visualstudio.com/docs/python/python-tutorial).
-->
## ✅ Speed Optimization:
- The program runs faster if MATLAB is already open before execution.
