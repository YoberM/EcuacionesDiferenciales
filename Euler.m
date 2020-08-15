% Metodo de Euler
function [tt, yy] = Euler(f,x0,y0,h,xf)
 k = ceil((xf - x0)/h);
 tt = zeros(k,1);
 yy = zeros(k,1);
 tt(1) = x0;
 yy(1) = y0;
 for i = 2:k
 tt(i) = tt(i-1) + h;
 m = f(tt(i-1),yy(i-1));
 yy(i) = yy(i-1) + h*m;
 end
end
