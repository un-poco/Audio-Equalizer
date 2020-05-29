function [Yf, f] = Spectrum_Calc(yt, Fs)
L = length(yt);
 
NFFT = 2^nextpow2(L);
Yf = fft(yt,NFFT)/L;
 
Yf = 2*abs(Yf(1:NFFT/2+1));
f = Fs/2*linspace(0,1,NFFT/2+1);
end
