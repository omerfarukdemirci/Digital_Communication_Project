
BW = 100e6;            % Bandwidth of matching network (Hz)
fc = 250e6;            % Center frequency (Hz)
Gt_target = 10;        % Transducer gain target (dB)
NFtarget = 3;          % Max noise figure target (dB)

Zs = 50;               % Source impedance (Ohm)
Z0 = 50;               % Reference impedance (Ohm)
Zl = 50;               % Load impedance (Ohm)

Unmatched_Amp = read(rfckt.amplifier,'lnadata.s2p'); % Create amplifier object

Npts = 32;                           % No. of analysis frequency points
fLower = fc - (BW/2);                % Lower band edge
fUpper = fc + (BW/2);                % Upper band edge
freq = linspace(fLower,fUpper,Npts); % Frequency array for analysis
w = 2*pi*freq;                       % Frequency (radians/sec)

analyze(Unmatched_Amp,freq,Zl,Zs,Z0);   % Analyze unmatched amplifier