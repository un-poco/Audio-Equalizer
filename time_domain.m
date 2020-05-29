%MUSIC:music signal; Fs; freq_gain:the gain of different frequency
function[gen_x] = time_domain(MUSIC,fs,freq_gain)
% filename = 'E:\学习资料\信号与系统\实验三\music_3\Bach2.wav';
% [MUSIC, fs] = audioread(filename);

%freq_gain = [0,4,4,3,2,-1,-1,0,1,3,4]; %古典
%freq_gain = [0,-1,-1,0,1,4,3,1,0,-1,1];%流行
gain = power(10,(freq_gain/10));

fa = fs/2;
%利用巴特沃斯滤波器实现时域滤波均衡器
%0--31频率段
[b,a] = butter(2,[1/fa,31/fa]);
y1=filter(b,a,MUSIC)*gain(1);   
 
[b,a] = butter(2,[31/fa,62/fa]);
y2=filter(b,a,MUSIC)*gain(2);
 
[b,a] = butter(2,[62/fa,125/fa]);
y3=filter(b,a,MUSIC)*gain(3);
 
[b,a] = butter(2,[125/fa,250/fa]);
y4=filter(b,a,MUSIC)*gain(4);
 
[b,a] = butter(2,[250/fa,500/fa]);
y5=filter(b,a,MUSIC)*gain(5);
 
[b,a] = butter(2,[500/fa,1000/fa]);
y6=filter(b,a,MUSIC)*gain(6);
 
[b,a] = butter(2,[1000/fa,2000/fa]);
y7=filter(b,a,MUSIC)*gain(7);
 
[b,a] = butter(2,[2000/fa,4000/fa]);
y8=filter(b,a,MUSIC)*gain(8);
 
[b,a] = butter(2,[4000/fa,8000/fa]);
y9=filter(b,a,MUSIC)*gain(9);
 
[b,a] = butter(2,[8000/fa,16000/fa]);
y10=filter(b,a,MUSIC)*gain(10);
 
%  [b,a] = butter(2,[16000/fa,20000/fa]);
%  y11=filter(b,a,MUSIC)*0;

gen_x = y1+y2+y3+y4+y5+y6+y7+y8+y9+y10;

% subplot(2,1,1);
% plot(MUSIC);
% title('原图像');
% subplot(2,1,2);
% plot(gen_x);
% title('滤波后');
% sound(gen_x, fs);
end