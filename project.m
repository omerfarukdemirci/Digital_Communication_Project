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
figure;
plot(t,signal);
mini=min(signal);
signal=signal-mini;
[index,digital_signal] = quantiz((2^nBits-1)*(signal),0:1:(2^nBits-1),0:1:(2^nBits));
digital_signal_2=de2bi(digital_signal,nBits);

figure;
plot(digital_signal_2);

digital_line=zeros(1,Vlength*Fs*8);
indexx=1;
for i=1:Vlength*Fs 
 digital_line(indexx:indexx+7)=digital_signal_2(i,:);  
 indexx=indexx+8;
end
save VoiceData digital_line mini nBits Fs Vlength;
