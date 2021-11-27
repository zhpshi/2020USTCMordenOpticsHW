%% 
 clc; clear;
lamda = 0.633;
k = 2 * pi / lamda;
f = 500;
N_x = 512;
N_z = 512;   %��������
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
Ein = E0 * lens;         % ͸��Բ�̵ĸ����

Iout = zeros(N_x + 1, N_z);
Eout = zeros(N_x + 1, N_z);

for m = 1 : N_z
    
    R = sqrt(z(m) ^ 2 + X .^ 2 + Y .^ 2);    % ���䴫���ռ����
    g = z(m) ./ (2 * pi * R .^ 2) .* (- 1i * k + 1 ./ R) .* exp( 1i * k * R);   % g����
    
    tic
    fg = fft2(g);
    fEin = fft2(Ein);
    Eout = fftshift(ifft2(fg .* fEin) );    % ������㣬�õ��������� 
    toc
    
    for n = 1 : N_x + 1
         Iout(n, m) = abs( Eout(n, N_x / 2 + 1) ) .^ 2;                % �����ǿ
    end
end

figure(2),imagesc(Iout);
colorbar,title('yzƽ���ǿ�ֲ�');
xlabel('Z(΢�ף�', 'Fontsize', 16); ylabel('Y(΢�ף�', 'Fontsize', 16);