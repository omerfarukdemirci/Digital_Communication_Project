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
Squaredata=zeros(1,length(data)*(length(tp)-1));
index1=1;
for i=1:length(data)
    for j=1:length(tp)-1
        Squaredata(index1)=pData(i);
        index1=index1+1;
    end
end
Squaredata=[Squaredata 0];
figure;
plot(Squaredata,'r-','LineWidth',2);
hold on;
plot(carrier,'g-','LineWidth',2);
grid on;
hold on;
%% modulate
mSig=Squaredata.*carrier;
plot(mSig,'b-','LineWidth',2);

%% channel

SNR=3;
ch=awgn(mSig,SNR,'measured');
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
%%
amp1=demSig*10;
p1=0;
for i=1:length(amp1)
p1=p1+abs(amp1(i))^2;
end
amp2=awgn(amp1,10*log(p1/10^0.3),'measured');

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
