 clear all;close all; clc;
load VoiceData;
data=digital_line;
pData=data*2-1;
fc=1000;
fcs=100*fc;
Ts=1/fcs;
Tc=1/fc;
M=10;
n=M*length(data);
t=0:Ts:n*Tc;
carrier=sin(2*pi*fc*t);
% subplot(2,1,1);
% stem(pData);
% subplot(2,1,2);
% plot(carrier);
%% squaredata
tp=0:Ts:Tc*M;
exdata=zeros(1,length(data)*(length(tp)-1));
dummy=1;
for i=1:length(data)
    for j=1:length(tp)-1
        exdata(dummy)=pData(i);
        dummy=dummy+1;
    end
end
exdata=[exdata 0];
% figure;
% plot(exdata,'r-','LineWidth',4);
% hold on;
% plot(carrier,'g-');
% grid on;
% hold on;
%% modulate
mSig=exdata.*carrier;
plot(mSig,'b-','LineWidth',2);

%% channel
figure;
SNR=50;
rx=awgn(mSig,SNR);
plot(mSig,'r-','LineWidth',3);
hold on;
plot(rx,'b-','LineWidth',1);
grid on;

%% demodulate
dem=rx.*carrier;
% figure;
% plot(dem);
% grid on;

%% decode
k=1;
rcv=zeros(1,length(data)); 
index=0;
for i=1:length(data)
   index=index+1;
    sm=0;
    for j=1:length(tp)-1
        sm=sm+ dem(k);
        k=k+1;
   end
    if(sm>0)
        rcv(index)=1;
    else
        rcv(index)=0;
    end
end

%% output
tl = (0:1:3*8000-1); 
out=[];
for j=0:3*8000-1
    out=[out ;bi2de(rcv((j*8)+(1:8)))];
    
end
out=(out/(2^8-1))+mini;
plot(tl,out);
sound(out);
clc; 
