clear all;close all; clc;
load VoiceData;
fc=99000000;
fcs=10*fc;
Ts=1/fcs;
Tc=1/fc;
M=1;
n=M*length(data);
t=0:Ts:n*Tc;
%% carrier
carrier=cos(2*pi*fc*t+(pi/2));
%% importing 
data=digital_line;
pData=data*2-1;
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

%% modulation
mSig=exdata.*carrier;

%% channel
SNR=3;
ch=awgn(mSig,SNR,'measured');
rx=ch/(10^6);


%% demodulation
demSig=rx.*carrier;

%% LNA
amp1=demSig*10;
amp2=awgn(amp1,7,'measured');
%% decoding
k=1;
rcv=zeros(1,length(data)); 
index=0;
for i=1:length(data)
   index=index+1;
    sm=0;
    for j=1:length(tp)-1
        sm=sm+ amp2(k);
        k=k+1;
   end
    if(sm>0)
        rcv(index)=1;
    else
        rcv(index)=0;
    end
end
%% BER
[number,ratio] = biterr(digital_line,rcv);
%% DAC
tl = (0:1:Fs*Vlength-1); 
out=zeros(1,Fs*Vlength-1);

for j=0:Fs*Vlength-1
    out(j+1)=bi2de(rcv((j*nBits)+(1:nBits)));
end
out=(out/(2^nBits-1))+mini;
plot(tl,out);
sound(out);
