clear all;close all; clc;
load VoiceData;
data=digital_line;
pData=data*2-1;
fc=99000000;
fcs=10*fc;
Ts=1/fcs;
Tc=1/fc;
M=1;
n=M*length(data);
t=0:Ts:n*Tc;
carrier=cos(2*pi*fc*t+(pi/2));

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

%% modulate
mSig=exdata.*carrier;


%% channel
Ber=zeros(2,60);
for q=0:60
SNR=q;
ch=awgn(mSig,SNR,'measured');
rx=ch/(10^6);


%% demodulate
demSig=rx.*carrier;

%% amplifier
amp1=demSig*10;

p1=sum(amp1.^2);

amp2=awgn(amp1,7,'measured');
%% decode
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
Ber(1,q+1)=ratio;
Ber(2,q+1)=number;
end
SNRx=1:61;
figure;
semilogy(SNRx,(Ber(1,:)),'rs');
xlabel('SNR') 
ylabel('BER') 