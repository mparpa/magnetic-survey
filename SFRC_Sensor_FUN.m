function [L] = SFRC_Sensor_FUN()
%% Reg Defaults - may not be same for all EVMs
regaddr=[0   1  2  3  4 5  6  7   8  9 10 11 20 21 22 23 24 25];  % Reg addresses
%reghex=['80';'13'; '35';'15';'17';'02';'05';'14';'c0'; '12';'04';'01']
regdat= [128 19 53 21 23 2 5 20 192 18  4  1  0  0  0  0  0  0]; % Reg contents

C=58.24e-9;

%% Open serial port
sport=LDC1000_open('COM3',5); % Modify serial port as needed
V=LDC1000_version(sport); % read version info
fset=LDC1000_setsamplerate(sport,10000); % set sample rate to 10000 Hz

%% Diable conversion (standby) to enable reg writes
w1=LDC1000_writereg(sport, 11, 0);

%% write reg contents - needed only if reg contents need to be modified
for i=1:length(regaddr)
   wreg(i) = LDC1000_writereg(sport, regaddr(i), regdat(i));
end
%% Enable conversion (active)

w1=LDC1000_writereg(sport, 11, 1);
% take measurements
pause(0.1)
N=10;
for i=1:N
d1=LDC1000_readreg(sport,hex2dec('23') );
d2=LDC1000_readreg(sport,hex2dec('24') );
d3=LDC1000_readreg(sport,hex2dec('25') );
pause(0.1)
Tp(i)=d3*2^16+d2*2^8+d1;
end
Tp_avr=mean(Tp);
fsen=1/3*6e6./mean(Tp_avr)*6144;
L=(1/(C*(2*pi*fsen)^2))*1e3  %mH

%% Close serial port
ret=LDC1000_close(sport);
return
