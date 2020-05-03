clc; clear;


M =  1; % 设置放大倍数


[object, map] = imread('a.bmp'); %导入图片和map
object = im2double(object);%将图片的值变成【0，1】上的双精度数，否则光强太大会得不到结果

[n_y, n_x] = size(object); %得到图片像素大小
lamda = 0.633; %照明光的波长
k = 2 * pi / lamda;
f = 100;  % 透镜焦距
D = 420; %透镜直径
dx = 0.3;
N = 6001; %N要保证能恰好覆盖最大的放大倍数的图片

z_1 = f * ( 1 / M + 1);
z_2 = M * z_1;    %由放大倍数得到物距和像距

x = (-(N - 1) / 2 : 1 : (N - 1) / 2) * dx;
y = (-(N - 1) / 2 : 1 : (N - 1) / 2) * dx;
[X, Y] = meshgrid(x, y); 

%扩充物体
Obj = zeros(N);
Obj (floor((N - n_x) / 2) + 1 : floor((N - n_x) / 2) + n_x, floor((N - n_y) / 2) + 1 : floor((N - n_y) / 2 + n_y)) = object;
figure(1);imshow( Obj, map);title('物体');%可能会看不到，因为对光强做了缩小，不影响结果

%第一次传输， 距离z1
E_front = RS_( Obj, z_1, lamda, N, N, dx, dx);
figure(2);imshow( abs( E_front) .^ 2, map);title('透镜前光场');

%定义凸透镜
lens = zeros(N);
for m = 1 : N
    for n = 1 : N
        if x(m) ^ 2 + y(n) ^ 2 <= ( D / 2) ^ 2
            lens(n, m) = 1 * exp( - 1i * k * ( x(m) ^ 2 + y(n) ^ 2) / f / 2);
        end
    end
end
figure(3); imshow( abs( lens ) .^ 2, map);title('透镜的强度值');%黑的，看不到

%凸透镜后的光场
E_behind = E_front .* lens;   
figure(4);imshow( abs( E_behind) .^ 2, map);title('透镜后光场');

%第二次传输，距离z1
E_image = RS_( E_behind, z_2, lamda, N, N, dx, dx);
Image = abs( E_image ) .^ 2;
figure(5);imshow( Image, map );title('M = 1');
