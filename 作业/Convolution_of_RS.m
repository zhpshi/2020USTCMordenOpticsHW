% 本程序计算圆形高斯光束入射到位于 束腰处的 圆盘产生的衍射及伯松亮斑
close all;clear all;
w = 0.25;                    % 入射光束腰，束腰半径为0.25mm
lamda = 0.632e-3;           % 入射激光波长
k = 2*pi/lamda;             % 波数
q = 1i*pi*w^2/lamda;        % 束腰处的q参数
N = 500;                    % 光强采样精度
x = linspace(-0.5,0.5,N);   % 观察光斑的坐标范围
z = 10;                     % 衍射传播的距离
E0 = exp(-1i*k*x.^2/2/q);   % 束腰处的光场复振幅分布

[X Y] = meshgrid(x,x);      % 坐标网格化
[Ex Ey] =meshgrid(E0,E0);   % 光场二维化
E1 = Ex.*Ey;                % 束腰处的二维光场
figure;imagesc(abs(E1).^2); % 圆形高斯光束
colormap hot;axis image;

Disk = ones(N);     % 定义半径为0.1mm的挡光圆盘
for m = 1:N
    for n = 1:N
        if sqrt(x(m)^2+x(n)^2) <= 0.1
            Disk(m,n) = 0;
        end
    end
end

Ein = E1.*Disk;         % 透过圆盘的复振幅
R = sqrt(z^2+X.^2+Y.^2);    % 衍射传播空间距离
coef = z./(2*pi*R) .*(1i*k -1./R) .*exp(-1i*k*R);   % 瑞利索末菲衍射系数
%% 如何能充分利用CPU的核心数目来加快计算二维卷积？
tic
Eout = conv2(coef,Ein,'same');  % 衍射的二维卷积计算，得到输出复振幅
toc
%% 如何能充分利用CPU的核心数目来加快计算二维卷积？

Iout = abs(Eout).^2;            % 输出光强
figure(1);imagesc(x,x,Iout);colormap hot;axis image off;
figure(2);mesh(Iout);view(0,82);colormap hot;axis off
