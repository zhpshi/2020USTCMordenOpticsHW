%% 
 clc; clear;
lamda = 0.633;
k = 2 * pi / lamda;
f = 500;
N_x = 512;
N_z = 512;   %采样精度
%% 

z = linspace(100, 1000, N_z);
E0 = 1;

x = linspace(-50, 50, N_x + 1);
[X, Y] = meshgrid(x, x);

r = zeros(N_x + 1);
P = zeros(N_x + 1);


for m = 1 : N_x + 1
    for n = 1 : N_x + 1
        if sqrt(x(m) ^ 2 + x(n) ^ 2) <= 50
            P(m, n) = 1; 
            r(m, n) = sqrt( x(m) ^ 2 + x(n) ^ 2 );
        end
    end
end

lens = P .* exp ( - 1i * k * ( r .^ 2 ) / 2 / f);
Ein = E0 * lens;         % 透过圆盘的复振幅

Iout = zeros(N_x + 1, N_z);
Eout = zeros(N_x + 1, N_z);

for m = 1 : N_z
    
    R = sqrt(z(m) ^ 2 + X .^ 2 + Y .^ 2);    % 衍射传播空间距离
    g = z(m) ./ (2 * pi * R .^ 2) .* (- 1i * k + 1 ./ R) .* exp( 1i * k * R);   % g函数
    
    tic
    fg = fft2(g);
    fEin = fft2(Ein);
    Eout = fftshift(ifft2(fg .* fEin) );    % 衍射计算，得到输出复振幅 
    toc
    
    for n = 1 : N_x + 1
         Iout(n, m) = abs( Eout(n, N_x / 2 + 1) ) .^ 2;                % 输出光强
    end
end

figure(2),imagesc(Iout);
colorbar,title('yz平面光强分布');
xlabel('Z(微米）', 'Fontsize', 16); ylabel('Y(微米）', 'Fontsize', 16);