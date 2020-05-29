function [yupper,c,f,p1] = get_envelope(instru)
file = [instru, '音节.wav'];
[ y, Fs ] = audioread(file);

% eps = 0.0001;%epsilon
% y=y-mean(y);%消去直流分量
% y=y./max(abs(y));%幅值归一化
% 
% %%帧数分割
% wlen = 320; movef=80; %wlen是帧长，movef是帧移
% overlap = wlen-movef;
% frame1 = frame_seg(wlen,movef,y(:,1));
% frame2 = frame_seg(wlen,movef,y(:,2));
% 
% %基于能熵比的音符分割算法
% fn = size(frame1,1);
% for i=1:fn
%     Sp = abs(fft(frame1(i,:)));%FFT取幅值
%     Sp = Sp(1:wlen/2+1);%只取正频率部分
%     E_sum(i) = sum(Sp.*Sp);
%     proba = Sp/sum(Sp);
%     H(i) = -sum(proba.*log(proba+eps));
% end
% Ef=sqrt(1+abs(E_sum./H));%?计算能熵比?
% Ef=Ef/max(Ef);%?归一化
% 
% %frame to time（将帧数转化到时域）
% frame_time = ((0:fn-1)*movef+wlen/2)/Fs;
% 
% %找极大极小（极小效果更好）
% threshold = 80;
% j=1;k=1;
% for i=threshold+1:(length(Ef)-500)
%     tag=0; %tag标记比邻居大的个数
%     for m=i-threshold:i+threshold
%         if Ef(i)>Ef(m)
%             tag = tag+1;
%         end
%     end
%     if(tag==2*threshold)
%         peek(j)=i;
%         j=j+1;
%     else if(tag==0)
%         trough(k)=i;
%         k=k+1;
%         end
%     end
% end
% %采用极小进行分割
% for i=1:length(trough)
%     time(i) = frame_time(trough(i)); 
% end
% 
% 
% y_index = round(Fs.*time);
% for i=0:length(y_index)-1
%     if i==0
%         y_segment{1}=y(1:y_index(1),:);
%     else
%         y_segment{i+1}=y(y_index(i):y_index(i+1),:);
%     end
% end


switch instru
    case '钢琴'
        index_segment=[47400,92905,138120,179970,228450,275040,324690,367500];
    case '吉他'
        index_segment=[54397,104840,159230,212610,268030,329010,387310,443730];
    case '萨克斯'
        index_segment=[53802,111490,171140,229250,286770,343539,407100,462795];
    case '铜管乐'
        index_segment=[48554,94109,148132,196113,244270,300365,349537,411541];
    case '弦乐'
        index_segment=[53581,115321,178076,241315,309201,371146,437957,531405];
    case '小提琴'
        index_segment=[52435,105002,163787,215208,278227,341643,399546,454671];
end

for i=0:length(index_segment)-1
    if i==0
        y_segment{1}=y(1:index_segment(1),:);
    else
        y_segment{i+1}=y(index_segment(i)+1:index_segment(i+1),:);
    end
end

%快速离散傅里叶变换
%计算双侧频谱 P2,然后基于 P2 和偶数信号长度 L 计算单侧频谱 P1
L = length(y_segment{2});
y_fourier = fft(y_segment{2});
p2 = abs(y_fourier/L);
p1 = p2(1:L/2+1);
f = Fs*(0:(L/2))/L;

%获取包络
%只plot upper的包络线
[yupper,~] = envelope(y_segment{2}, 2000, 'peak');
yupper = yupper(:,1);

c = freq_amp_store(instru);
% c(1) = 0.27; c(2) =0.197; c(3) =0.172; c(4)=0.147; c(5)=0.037; c(6)=0.086; c(7)=0.317; c(8)=0.018; c(9)=0.01; c(10)=0.07;

end
