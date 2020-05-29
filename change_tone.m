function [s]=change_tone(y0,b)

u=round(b*2000);
ResampleSign=resample(y0,u,2000); %重采样信号
S=800;                       %一帧的长度
Overlap=400;                 %重叠叠加区间长度
Pmax=300;                    %允许寻找相关性最大移动位数
B=S-Overlap;                 %输出序列间距
OriginalLen= length(y0);  %原始信号的序列长度
s= zeros(1, OriginalLen);      %为新序列开辟原始信号的长度
ratio = (1:Overlap)/(Overlap+1); %加权叠加系数
i = 1:Overlap;
app=1:B;                        %信号追加移动变量
%以重采样信号为模板新建序列用以计算
CalSeries = [ResampleSign, zeros(1,800)];
%取原始信号第一帧给（将要规整的）新信号
s(1:S) = ResampleSign(1:S);
for newpos = B:B:(OriginalLen-S)
    Originalpos = round(b * newpos);
    y = s(newpos + i);
    rxy = zeros(1, Pmax+1);
    rxx = zeros(1, Pmax+1);
    Pmin=0;
    %相关性计算
    for p =Pmin:Pmax
        x = CalSeries(Originalpos + p + i);
        rxx(p+1) = norm(x);
        rxy(p+1) = (y*x');
    end
    Rxy = (rxx ~= 0).*rxy./(rxx+(rxx==0));
    pm = min(find(Rxy == max(Rxy))-1);
    bestpos = Originalpos+pm;              %当前最佳匹配位置
    %加权叠加
    s(newpos+i)=((1-ratio).*s(newpos+i))+(ratio.*CalSeries(bestpos+i));
    %去除重叠部分信号追加在新信号输出序列
    s(newpos+Overlap+app) = CalSeries(bestpos+Overlap+app);
end