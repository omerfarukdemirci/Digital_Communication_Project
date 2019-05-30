close all; clear all; clc;
Fs = 8000 ; 
nBits = 8 ; 
nChannels = 1 ; 
Vlength=10;
ID = -1; % default audio input device 
recObj = audiorecorder(Fs,nBits,nChannels,ID);
disp('Start speaking.')
recordblocking(recObj,Vlength);
disp('End of Recording.');
signal = getaudiodata(recObj);
t = (0:1:Vlength*Fs-1);  
t_1 = (0:1:1279999);
figure;
plot(t,signal);
mini=min(signal);
signal=signal-mini;
quant=max(signal)/(2^nBits-1);
%%digital_signal=signal/quant;
[index,digital_signal] = quantiz((2^nBits-1)*(signal),0:1:(2^nBits-1),0:1:(2^nBits));
digital_signal_2=de2bi(digital_signal,nBits);

figure;
plot(digital_signal_2);
digital_line=[];
for i=1:Vlength*Fs 
 digital_line=[digital_line digital_signal_2(i,:)];  
end
out=[];
figure;
for j=0:Vlength*Fs-1
    out=[out ;bi2de(digital_line((j*nBits)+(1:nBits)))];
    
end
out=(out/(2^nBits-1))+mini;
plot(t,out);
sound(out);
save VoiceData digital_line mini nBits Fs Vlength;
% %%
% isequal(transpose(digital_signal),out)
% %%
% elements(1) = nport('sawfilterpassive.s2p');
% elements(2) = amplifier(                                                ...
%     'Name','LNA',                                                       ...
%     'Gain',10,                                                          ...
%     'NF',3);
% elements(3) = modulator(                                                ...
%     'Name','Demod',                                                     ...
%     'Gain',10,                                                          ...
%     'NF',6.4,                                                          ...
%     'LO',2.45e9,                                                        ...
%     'ConverterType','Down');
% elements(4) = amplifier(                                                ...
%     'Gain',20,                                                          ...
%     'NF',11.3);
% b = rfbudget(                                                           ...
%     'Elements',elements,                                                ...
%     'InputFrequency',2.45e9,                                            ...
%     'AvailableInputPower',-70,                                          ...
%     'SignalBandwidth',8e6);
% show(b)