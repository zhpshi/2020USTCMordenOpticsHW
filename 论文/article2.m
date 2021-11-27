clc; clear;

[object, map] = imread('i1.jpg'); %����ͼƬ��map
object = im2double( object );%��ͼƬ��ֵ��ɡ�0��1���ϵ�˫�������������ǿ̫���ò������

[n_y, n_x] = size(object); %�õ�ͼƬ���ش�С
lamda = 0.15; %������Ĳ���
k = 2 * pi / lamda;
f = 450;  % ͸������
D = 450; %͸��ֱ��
dx = 0.3;

z_1 = f ;
z_2 = f;    %�ɷŴ����õ��������

%��������
%N = 601;
% Obj = zeros(N);
% Obj (floor((N - n_x) / 2) + 1 : floor((N - n_x) / 2) + n_x, floor((N - n_y) / 2) + 1 : floor((N - n_y) / 2 + n_y)) = object;

N = n_x;
Obj = zeros(N);
Obj = object;

x = (-(N - 1) / 2 : 1 : (N - 1) / 2) * dx;
y = (-(N - 1) / 2 : 1 : (N - 1) / 2) * dx;
[X, Y] = meshgrid(x, y); 

figure(1);imshow( Obj, map);title('����');%���ܻῴ��������Ϊ�Թ�ǿ������С����Ӱ����

%��һ�δ��䣬 ����z1
E_front = RS_( Obj, z_1, lamda, N, N, dx, dx);
%figure(2);imshow( abs( E_front) .^ 2, map);title('͸��ǰ�ⳡ');

%����͹͸��
lens = zeros(N);
for m = 1 : N
    for n = 1 : N
        if x(m) ^ 2 + y(n) ^ 2 <= ( D / 2) ^ 2
            lens(n, m) = 1 * exp( - 1i * k * ( x(m) ^ 2 + y(n) ^ 2) / f / 2);
        end
    end
end
%figure(3); imshow( abs( lens ) .^ 2, map);title('͸����ǿ��ֵ');%�ڵģ�������

%͹͸����Ĺⳡ
E_behind = E_front .* lens;   
%figure(4);imshow( abs( E_behind) .^ 2, map);title('͸����ⳡ');

%�ڶ��δ��䣬����z2
E_spectro = RS_( E_behind, z_2, lamda, N, N, dx, dx);
Spectroscopy = abs( E_spectro ) .^ 2;
figure(5);imshow( Spectroscopy, map );title('Ƶ����');

%%%%�����˲���%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
filter_operator1 = [-1,-2,-1;0,0,0;1,2,1];
filter_operator2 = [-1,0,1;-2,0,2;-1,0,1];
filter1 = fftshift(ifft2(filter_operator1, N, N));
filter2 = fftshift(ifft2(filter_operator2, N, N));
E_filtered1 = E_spectro .* filter1;
E_filtered2 = E_spectro .* filter2;
%%%%%�ڶ���͸��%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
 du = dx / lamda / f ;
E_front21 = RS_( E_filtered1, z_1, lamda, N, N, dx, dx);
E_front22 = RS_( E_filtered2, z_1, lamda, N, N, dx, dx);
E_behind21 = E_front21 .* lens;
E_behind22 = E_front22 .* lens;
E_final1 = RS_( E_behind21, z_2, lamda, N, N, dx, dx);
E_final2 = RS_( E_behind22, z_2, lamda, N, N, dx, dx);

Final_image1 = 1000 * abs(E_final1) .^ 2;
Final_image2 = 1000 * abs(E_final2) .^ 2;
F = sqrt(Final_image1 .^ 2 + Final_image2 .^ 2);
figure(6);imshow( F, map );title('');

Filtered_image1 = conv2( Obj, filter_operator1, 'same');
Filtered_image2 = conv2( Obj, filter_operator2, 'same');
FF = sqrt(Filtered_image1 .^ 2 + Filtered_image2 .^ 2);
figure(7); imshow( FF );title('');

figure(1);
subplot(1, 2, 1);
imshow( object );
title('ԭͼ');

subplot(1, 2, 2);
imshow( F );
title('4fϵͳ������');

% subplot(1, 3, 3);
% imshow( FF );
% title('ֱ�Ӿ��������');

% E_behind2 = E_spectro .* lens;
% E_final = RS_( E_behind2, z_2, lamda, N, N, dx, dx);
% Final_image = abs(E_final) .^ 2;
% figure(6);imshow( Final_image, map );title('����ͼƬ');