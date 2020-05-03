function Eout = RS_(Ein, z, lamda, N_x, N_y, dx, dy)
%此函数为Rayleigh-Sommerfield衍射积分函数 Eout为输入光场
%   Ein为入射光场
%   z为传播距离
%   lamda为光波长
%   N_x,N_y 为Eout水平和垂直方向的像素个数
%   dx dy为水平垂直方向的采样间隔
k = 2 * pi / lamda;
x = ( -(N_x - 1) / 2 : 1 : (N_x - 1) / 2) * dx;
y = ( -(N_y - 1) / 2 : 1 : (N_y - 1) / 2) * dy;
[X, Y] = meshgrid(x, y);

R = sqrt(z ^ 2 + X .^ 2 + Y .^ 2);
g = z ./ (2 * pi * R .^ 2 ) .* (- 1i * k + 1 ./ R) .* exp(1i * k * R); %g函数，很重要

fg = fft2(g, N_x, N_y);
fEin = fft2(Ein, N_x, N_y);
Eout = fftshift(ifft2(fg .* fEin));
end

