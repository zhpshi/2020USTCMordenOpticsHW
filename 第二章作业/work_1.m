clc;clear;
lamda = 0.633;              % 入射激光波长
k = 2 * pi/lamda;           % 波数
N_x = 512;                  % 光强采样精度
N_z = 512;
x = linspace(-8, 8, N_x);   % 观察光斑的坐标范围
z = linspace(0, 100, N_z);   % 衍射传播的距离
E0 = 10;
 

[X, Y] = meshgrid(x, x);      % 坐标网格化
[Ex, Ey] =meshgrid(E0, E0);   % 光场二维化
E1 = Ex .* Ey;                % 二维光场


Disk = ones(N_x);     % 定义半径为0.1mm的挡光圆盘
for m = 1:N_x
    for n = 1:N_x
        if sqrt(x(m) ^ 2 + x(n) ^ 2) >= 5
            Disk(m , n) = 0;
        end
    end
end
Iout = zeros(N_x, N_z);
Ein = E1 .* Disk;         % 透过圆盘的复振幅

for m = 1 : N_z
    R = sqrt(z(m) ^ 2 + X .^ 2 + Y .^ 2);    % 衍射传播空间距离
    g = z(m) ./ (2 * pi * R .^ 2 ) .* (- 1i * k + 1 ./ R) .* exp(1i * k * R);   % 瑞利索末菲衍射系数
    tic
    fg = fft2(g);
    fEin = fft2(Ein);
    Eout = fftshift( ifft2(fg .* fEin));   % 衍射的二维 
    toc
    for n = 1 : N_x
         Iout(n, m) = abs( Eout(n, N_x / 2)) .^2;                % 输出光强
    end
end

figure(2),imagesc(Iout);
colorbar,title('yz平面光强分布');axis off;