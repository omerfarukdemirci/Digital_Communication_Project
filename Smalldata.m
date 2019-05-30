clear all;close all; clc;
load VoiceData;
data=[ 0 0 1 0 1 1 0];
pData=data*2-1;
fc=99000000;
fcs=10*fc;
Ts=1/fcs;
Tc=1/fc;
M=1;
n=M*length(data);
t=0:Ts:n*Tc;
carrier=cos(2*pi*fc*t+(pi/2));
subplot(2,1,1);
stem(pData);
subplot(2,1,2);
plot(carrier);
%% squaredata
tp=0:Ts:Tc*M;
exdata=zeros(1,length(data)*(length(tp)-1));
index1=1;
for i=1:length(data)
    for j=1:length(tp)-1
        exdata(index1)=pData(i);
        index1=index1+1;
    end
end
exdata=[exdata 0];
figure;
plot(exdata,'r-','LineWidth',2);
hold on;
plot(carrier,'g-','LineWidth',2);
grid on;
hold on;
%% modulate
mSig=exdata.*carrier;
plot(mSig,'b-','LineWidth',2);

%% channel

SNR=3;
ch=awgn(mSig,SNR);
rx=ch/(10^6);

figure;
plot(mSig,'r-','LineWidth',3);
hold on;
plot(rx,'b-','LineWidth',1);
grid on;


%% demodulate
demSig=rx.*carrier;
figure;
plot(demSig,'b-','LineWidth',4);
grid on;
hold on
plot(mSig,'r-','LineWidth',2);
%% decode
k=1;
rcv=zeros(1,length(data)); 
index=0;
for i=1:length(data)
   index=index+1;
    sm=0;
    for j=1:length(tp)-1
        sm=sm+ demSig(k);
        k=k+1;
    end
   
    if(sm>0)
        rcv(index)=1;
    else
        rcv(index)=0;
    end
end

%% output
h = rf.amplifier;
unmatched_amp = read(rfckt.amplifier, 'samplelna1.s2p');
analyze(unmatched_amp, 2e9:50e6:10e9);
figure
plot(unmatched_amp,'Gmag','Ga','Gt','dB')
% tl = (0:1:Fs*Vlength-1); 
% out=zeros(1,Fs*Vlength-1);
% 
% for j=0:Fs*Vlength-1
%     out(j+1)=bi2de(rcv((j*nBits)+(1:nBits)));
% end
% out=(out/(2^nBits-1))+mini;
% plot(tl,out);
% sound(out);

