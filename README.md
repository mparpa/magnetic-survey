# magnetic-survey

## General info
MATLAB code for grid magnetic survey and post-processing using Texas Instrument LDC1000. The repo contains a main written by the present author which calls TI matlab code.

## Usage
The `SENSOR_MAIN.m` is the **main** that is to be run. This is meant to automatize magnetic surveys on grids. It produces a file.txt in which all the data are saved and it also post-processes the results by displaying a contour figure.

For each element of the grid it must be taken 4 measures positioning the instrument at 0°, 45°, 90° and 135° with respect to the ground surface. The post-processing considers an average of all these measures in each element of the grid.

The user is prompted to insert the size of the grid (rows and columns) and the `filename.txt` to save all the registered data into. Once the configuration part ends the user can start taking measures, with the possibility of accepting or rejecting the results (for instance if the instruments was not correctly placed). In all the cases the default answer is YES (this means that to enter yes it is just needed to press `ENTER`).

At the beginning of the code there is the possibility to set a variable `ICODE = 0` or `ICODE = 1`. 
`IF = 0`, the script produces only the value `L` without any saving or post processing.
`IF = 1`, the script does all the above mentioned actions.

***Important: In order to function properly, it is needed to set the correct Serial port in `SFRC_Sensor_FUN.m`, see line 10 of the code***

The script requires the following functions (devel. by Texas Instrument):
- Function used to prompt instrument:
    -- `SFRC_Sensor_FUN.m`: this was previosly the main used to interact with LDC1000 instrument (LDC1000_Script.m). The main was converted into a function.
    
- Open and Close Serial Port:
    -- `LDC1000_open.m`
    -- `LDC1000_close.m`
    
- Stream Data:
    -- `LDC1000_setsamplerate.m`
    -- `LDC1000_startstream.m`
    -- `LDC1000_stopstream.m`
    -- `LDC1000_streamdata.m`

- Read / Write Registers:
    -- `LDC1000_readreg.m`
    -- `LDC1000_writereg.m`

- Misc:
    -- `LDC1000_version.m`

