clc; clear;

[object, map] = imread('j1.jpg'); %����ͼƬ��map
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
filter_operator = [0,0,-1,0,0;0,-1,-2,-1,0;-1,-2,16,-2,-1;0,-1,-2,-1,0;0,0,-1,0,0];
%filter_operator = [-1,0,1;-2,0,2;-1,0,1];
filter = fftshift(ifft2(filter_operator, N, N));
E_filtered = E_spectro .* filter;
%%%%%�ڶ���͸��%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
 du = dx / lamda / f ;
E_front2 = RS_( E_filtered, z_1, lamda, N, N, dx, dx);
E_behind2 = E_front2 .* lens;
E_final = RS_( E_behind2, z_2, lamda, N, N, dx, dx);

Final_image = 1000 * abs(E_final) .^ 2;
Final_image1 = Final_image';
figure(6);imshow( Final_image, map );title('����ͼƬ');

Filtered_image = conv2( Obj, filter_operator, 'same');
figure(7); imshow( Filtered_image );title('ֱ�Ӿ������');

figure(8); imagesc(abs(filter));

% E_behind2 = E_spectro .* lens;
% E_final = RS_( E_behind2, z_2, lamda, N, N, dx, dx);
% Final_image = abs(E_final) .^ 2;
% figure(6);imshow( Final_image, map );title('����ͼƬ');