%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%     MATLAB MAIN FOR AUTOMATIZING MAGNETIC SURVEY   %%%%%%%%%%%%%
%%%%%%%%%%              Author: Matteo Parpanesi              %%%%%%%%%%%%%
%%%%%%%%%%        E-mail: matteo.parpanesi@mail.polimi.it     %%%%%%%%%%%%%
%%%%%%%%%%                  16 - May - 2021                   %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------------------------------------------------------------%
%README:
%   Script for automatizing magnetic surveys on grids.
%   It produces a file.txt in which all the data are saved and it
%   also post-processes the results by displaying a contour figure. For
%   each element of the grid it must be taken 4 measures positioning the
%   instrument at 0°, 45°, 90° and 135° with respect to the ground surface.
%   The post-processing considers an average of all these measures in each
%   element of the grid.
%
%   The user is prompted to insert the size of the grid (rows and columns)
%   and the filename.txt to save all the registered data into.
%   Once the configuration part ends the user can start taking measures,
%   with the possibility of accepting or rejecting the results
%   (for instance if the instruments was not correctly placed). In all the
%   cases the default answer is YES (this means that to enter yes it is
%   just needed to press ENTER).
%
%   At the beginning of the code there is the possibility to set a variable
%   ICODE = 0 or = 1. IF = 0, the script produces only the value L without
%   any saving or post processing. IF = 1, the script does all the above
%   mentioned actions.
%
% The script requires the following functions (devel. by Texas Instrument):
%       - SFRC_Sensor_FUN.m : this was previosly the main used to interact
%       with LDC1000 instrument (LDC1000_Script.m). The main was converted 
%       into a function.
%
%       - Open and Close Serial Port:
%           -- LDC1000_open.m
%           -- LDC1000_close.m
%
%       - Stream Data:
%           -- LDC1000_setsamplerate.m
%           -- LDC1000_startstream.m
%           -- LDC1000_stopstream.m
%           -- LDC1000_streamdata.m
%
%       - Read / Write Registers:
%           -- LDC1000_readreg.m
%           -- LDC1000_writereg.m
%
%       - Misc:
%           -- LDC1000_version.m


%% Initialization

clear all
close all
clc
%% MEASUREMENT TYPE
%Uncomment just one of the two according to above "readme"

%ICODE = 0;     %only display value of L
ICODE = 1;      %saving and post-processing results

%% CODE

if ICODE == 0
    L = SFRC_Sensor_FUN();
elseif ICODE == 1
    %% GRID DEFINITION
    %   Ask the size of the grid to analyze
    fprintf('Which is the size of the grid you are surveying?\n');
    rowAsk = 'Number of rows: ';
    colAsk = 'Number of columns: ';

    r = input(rowAsk,'s');              %r: row number
    while isempty(str2num(r))
        disp('NOT COMPATIBLE DATA');
        r = input(rowAsk,'s');
    end
    r = str2num(r);

    c = input(colAsk,'s');              %c: column number
    while isempty(str2num(c))
        disp('NOT COMPATIBLE DATA');
        c = input(colAsk,'s');
    end
    c = str2num(c);

    %File name with the name of the line to be surveyed
    rigaAsk = 'Name of the file to save results? (i.e. Slab1.txt)\n';
    rigaAns = input(rigaAsk,'s');

    %   Prompt the way of proceeding
    fprintf('--- WARNING --- \nThe correct funcitoning of the programm requires proceeding from:\n TOP LEFT IN HORIZONTAL\n');
    input('\n\nPres ENTER to end the configuration part');
    clc     %clear previous messages

    %% MEASUREMENTS
    %Initialize matrix to store data
    DATA = zeros(4*r,c);
    %Open document to write results
    fileID = fopen(rigaAns,'w');

    %For each line take c*4 measures
    for i = 1:r
        for j = 1:c
            fprintf(fileID, '\nRow %i, Col %i\n', i, j);
            for k = 1:4
                fprintf('Row %i, Col %i, Orientation %i\n',i, j, k);
                %Press enter to take measure
                input('Press ENTER to take measure: \n');
                L = SFRC_Sensor_FUN();
                %Prompting if result was good
                answer = 'n'; %initialize
                while (answer == 'n')
                    prompt = 'Was the measure satisfactory? y/n [y] \n';
                    answer = input(prompt,'s');
                    if isempty(answer)
                        answer = 'y';
                    end
                    if answer == 'y'
                        DATA(((i-1)*4+k),j) = L;
                        fprintf(fileID, '%10.4f \n', L);
                        disp('Result is registered')
                    else
                    input('Press ENTER to take AGAIN measure \n');
                    L = SFRC_Sensor_FUN();
                    end
                end
            end
        end
    end

    %closing .txt file
    fclose(fileID);

    %% ANALYSIS and PLOT
    DATA_AV = zeros(r,c);
    for i = 1:r
        for j = 1:c
            sum = 0;
            for k = 1:4
                sum = sum + DATA(((i-1)*4 + k),j);
            end
            DATA_AV(i,j) = sum/4;
        end
    end

    clims = [11 13]; %limit of colourmap legenda
    figure;
    imagesc(DATA_AV, clims);    
    colorbar
    %title('Grid %d x %d', r, c);
    saveas(gcf, 'figure.png');
else
    disp('WARNING --- incorrect value of ICODE');
end





