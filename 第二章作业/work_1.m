clc;clear;
lamda = 0.633;              % ���伤�Ⲩ��
k = 2 * pi/lamda;           % ����
N_x = 512;                  % ��ǿ��������
N_z = 512;
x = linspace(-8, 8, N_x);   % �۲��ߵ����귶Χ
z = linspace(0, 100, N_z);   % ���䴫���ľ���
E0 = 10;
 

[X, Y] = meshgrid(x, x);      % ��������
[Ex, Ey] =meshgrid(E0, E0);   % �ⳡ��ά��
E1 = Ex .* Ey;                % ��ά�ⳡ


Disk = ones(N_x);     % ����뾶Ϊ0.1mm�ĵ���Բ��
for m = 1:N_x
    for n = 1:N_x
        if sqrt(x(m) ^ 2 + x(n) ^ 2) >= 5
            Disk(m , n) = 0;
        end
    end
end
Iout = zeros(N_x, N_z);
Ein = E1 .* Disk;         % ͸��Բ�̵ĸ����

for m = 1 : N_z
    R = sqrt(z(m) ^ 2 + X .^ 2 + Y .^ 2);    % ���䴫���ռ����
    g = z(m) ./ (2 * pi * R .^ 2 ) .* (- 1i * k + 1 ./ R) .* exp(1i * k * R);   % ������ĩ������ϵ��
    tic
    fg = fft2(g);
    fEin = fft2(Ein);
    Eout = fftshift( ifft2(fg .* fEin));   % ����Ķ�ά 
    toc
    for n = 1 : N_x
         Iout(n, m) = abs( Eout(n, N_x / 2)) .^2;                % �����ǿ
    end
end

figure(2),imagesc(Iout);
colorbar,title('yzƽ���ǿ�ֲ�');axis off;