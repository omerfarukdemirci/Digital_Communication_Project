SNR=[0 1 2 3 4 5 6 7 8 9 10]%or use steps of 2 upto 20
BER=[]
data_len=1e6
for i=1:length(SNR)% or simply use i=1:20
snr=SNR[i];

data=generate_data(data_len);
tx=bpsk_modulation(data)
rx=awgn(tx,snr);
data_rx=bpsk_demodulation(rx);
b=ber(data,data_rx);
BER=[BER b];
end
semilogx(SNR,BER);
%semilogx(BER); If using i=1:20
grid on;