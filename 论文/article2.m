clc; clear;

[object, map] = imread('i1.jpg'); %导入图片和map
object = im2double( object );%将图片的值变成【0，1】上的双精度数，否则光强太大会得不到结果

[n_y, n_x] = size(object); %得到图片像素大小
lamda = 0.15; %照明光的波长
k = 2 * pi / lamda;
f = 450;  % 透镜焦距
D = 450; %透镜直径
dx = 0.3;

z_1 = f ;
z_2 = f;    %由放大倍数得到物距和像距

%扩充物体
%N = 601;
% Obj = zeros(N);
% Obj (floor((N - n_x) / 2) + 1 : floor((N - n_x) / 2) + n_x, floor((N - n_y) / 2) + 1 : floor((N - n_y) / 2 + n_y)) = object;

N = n_x;
Obj = zeros(N);
Obj = object;

x = (-(N - 1) / 2 : 1 : (N - 1) / 2) * dx;
y = (-(N - 1) / 2 : 1 : (N - 1) / 2) * dx;
[X, Y] = meshgrid(x, y); 

figure(1);imshow( Obj, map);title('物体');%可能会看不到，因为对光强做了缩小，不影响结果

%第一次传输， 距离z1
E_front = RS_( Obj, z_1, lamda, N, N, dx, dx);
%figure(2);imshow( abs( E_front) .^ 2, map);title('透镜前光场');

%定义凸透镜
lens = zeros(N);
for m = 1 : N
    for n = 1 : N
        if x(m) ^ 2 + y(n) ^ 2 <= ( D / 2) ^ 2
            lens(n, m) = 1 * exp( - 1i * k * ( x(m) ^ 2 + y(n) ^ 2) / f / 2);
        end
    end
end
%figure(3); imshow( abs( lens ) .^ 2, map);title('透镜的强度值');%黑的，看不到

%凸透镜后的光场
E_behind = E_front .* lens;   
%figure(4);imshow( abs( E_behind) .^ 2, map);title('透镜后光场');

%第二次传输，距离z2
E_spectro = RS_( E_behind, z_2, lamda, N, N, dx, dx);
Spectroscopy = abs( E_spectro ) .^ 2;
figure(5);imshow( Spectroscopy, map );title('频谱面');

%%%%加入滤波器%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
filter_operator1 = [-1,-2,-1;0,0,0;1,2,1];
filter_operator2 = [-1,0,1;-2,0,2;-1,0,1];
filter1 = fftshift(ifft2(filter_operator1, N, N));
filter2 = fftshift(ifft2(filter_operator2, N, N));
E_filtered1 = E_spectro .* filter1;
E_filtered2 = E_spectro .* filter2;
%%%%%第二个透镜%%%%%%%%%%%
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
title('原图');

subplot(1, 2, 2);
imshow( F );
title('4f系统处理结果');

% subplot(1, 3, 3);
% imshow( FF );
% title('直接卷积处理结果');

% E_behind2 = E_spectro .* lens;
% E_final = RS_( E_behind2, z_2, lamda, N, N, dx, dx);
% Final_image = abs(E_final) .^ 2;
% figure(6);imshow( Final_image, map );title('最终图片');