function [y] = wsola(x, rate)
    lx = size(x,2); 
    N = 1024;
    delta = N / 2;
    Hs = N / 2;
    Ha = round(Hs./rate);
    Ha = Ha(1);
    w = hanning(N)';
    ly = round(lx.*rate);
    ly = ly(1)
    y = zeros(1,ly);
    flag = 0;
    xm = x(1:N);
    ym = xm.*w;
    for j = 1:N
        y(j) = y(j) + ym(j);
    end
    x_p = x(N/2+1:3*N/2);
    s = N/2+1;
    p = Ha + 1;
    l = p - delta;
    r = p + delta - 1;
    count = 1;
    while r+N-1 <= lx
        if l < 1
            l = 1;
        end
     b_p = best_xm(x, l, r, x_p, N);
            
        xm = x(b_p:b_p + N - 1);
        p = p + Ha;
        l = p - delta;
        r = p + delta - 1;
        ym = xm.*w;
        count = count + 1;
        temp = (count-1)*Hs;
        if temp+N > ly
            for j = 1:Hs
                y(temp+j) = y(temp+j) + ym(j);
            end
            for j = temp+Hs+1:ly
                y(j) = y(j) + ym(j-temp);
            end
            flag = 1;
            break;
        else
            for j = 1:N
                y(temp+j) = y(temp+j) + ym(j);
            end
        end
        s = b_p + N/2;
        if s+ N - 1 > lx
            break;
        end
        x_p = x(s:s + N - 1);
    end
    
    if flag == 0
        if rate <= 1
            for j = temp + N/2+1:ly
                mm = b_p + j - temp - 1;
                if mm > lx
                    break;
                else
                    y(j) = x(mm);
                end
            end
        else
            r = lx - N +1;
            l = r - 2*delta + 1;

            while 1
                x_p = x(b_p + N/2:b_p + N - 1);
                b_p = best_xm(x, l, r, x_p, N / 2);
                xm = x(b_p:b_p + N - 1);
                ym = xm.*w;
                temp = temp + Hs;
                if temp + N <= ly
                    for j = 1:N
                        y(temp+j) = y(temp+j) + ym(j);
                    end
                else
                    for j = 1:Hs
                        y(temp+j) = y(temp+j) + ym(j);
                    end
                    for j = temp + Hs + 1:ly
                        y(j) = xm(j- temp);
                    end
                    break;
                end
            end
        end
    end
end