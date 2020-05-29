function y = generate_tone(freq,time,fs, tone_choose, yupper, c)
%%freq代表基准频率信号，time为每个音调的时长
%获得带有谐波和包络的信号

%谐波
Z=2^(1/12);     %基本音频率
tA=220; tB=tA*Z^2; tC=tA*Z^3; tD=tA*Z^5; tE=tA*Z^7; tF=tA*Z^8; tG=tA*Z^10;
tones=[tA tB tC tD tE tF tG];
tone = tones(tone_choose);%演奏的调号
do=tone; lai=tone*Z^2; mi=tone*Z^4; fa=tone*Z^5;    %演奏的音节
so=tone*Z^7; la=tone*Z^9; xi=tone*Z^11;

num = 0;
switch freq
    case do
        num = 1;
    case lai
        num = 2;
    case mi
        num = 3;
    case fa
        num = 4;
    case so
        num = 5;
    case la
        num = 6;
    case xi
        num = 7;
        
    case do*2
        num = 1;
    case lai*2
        num = 2;
    case mi*2
        num = 3;
    case fa*2
        num = 4;
    case so*2
        num = 5;
    case la*2
        num = 6;
    case xi*2
        num = 7;
    
    case do/2
        num = 1;
    case lai/2
        num = 2;
    case mi/2
        num = 3;
    case fa/2
        num = 4;
    case so/2
        num = 5;
    case la/2
        num = 6;
    case xi/2
        num = 7;
end

t = 0:1/fs:(time-1/fs);
y = zeros(1,length(t));

%谐波
if num ~= 0
    for count = 1:size(c,2)
        y = y+c(num, count)*sin(2*pi*t*freq*count);
    end
end

%包络
for j = 1:length(y)
    n = j/length(y);
    n = ceil(n*length(yupper));
    y(1,j) = y(1,j) * yupper(n);
end
end

