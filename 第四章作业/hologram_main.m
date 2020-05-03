  clc; clear;
  
  dx = 0.3; %取样间隔单位um
  size_of_pic = 500; %目标图片的大小， 单位um
  cycle_index = 10;%循环次数
  image00 = imread('4.jpg');%导入图片
  
  %计算像素个数， 保证能覆盖图片。且为了让图片中心对称，保证N为奇数
  N = ceil( size_of_pic / dx); 
  if mod(N, 2) == 0
      N = N + 1;
  end
  
  %激光参数
  w_0 = 200;%束腰半径
  lamda = 0.6328; %waveLength
  z = 400;
  x_0 = (-(N - 1) / 2 : 1 : (N - 1) / 2) * dx;
  y_0 = (-(N - 1) / 2 : 1 : (N - 1) / 2) * dx;
  [Y, X] = meshgrid(x_0, y_0);
  U_i = 0.1 * exp(-(X .^ 2 + Y .^ 2) / w_0 ^ 2); %高斯光束
  %U_i = 0.1; %平面光备用
  
  %采样
  %image00 = rgb2gray(image00);%变成灰度图
  image_0 = im2double(image00);%变成double矩阵，实际模拟中用到的
  [h, w] = size(image_0);%获取大小
  
  %把图片变成N*N型，这里的做法比较暴力，直接切割或者四周扩充，如果要更好的效果需要插值算法
  %因此所选的图片像素数最好和N*N十分接近
  image_1 = zeros(N);
  if N - h >= 0
      if N - w >= 0
          image_1 ( floor((N - h) / 2) + 1 : floor((N - h) / 2) + h, floor((N - w) / 2) + 1 : floor((N - w) / 2) + h ) = image_0;%对目标图片扩充
      else
          image_1( floor((N - h) / 2) + 1 : floor((N - h) / 2) + h, : ) = image_0( : , floor((w - N) / 2) + 1 : floor((w - N) / 2) + N);
      end
  else 
      if N - w >= 0
          image_1 ( : , floor((N - w) / 2) + 1 : floor((N - w) / 2) + h) = image_0( floor((h - N) / 2) + 1 : floor((h - N) / 2) + N, : );
      else
          image_1 = image_0(floor((h - N) / 2) + 1 : floor((h - N) / 2) + N, floor((w - N) / 2) + 1 : floor((w - N) / 2) + N);
      end
  end
  %image_1是最终使用的原图       
  amplitude_image = sqrt(image_1);%提取振幅
  
  %输出原图
  figure;
  subplot(1, 2, 1);
  imshow(image_1);
  title('原图');
  
  %生成全息片上的随机相位
  radius = 100;
  disk = zeros(N);
  for m = 1 : N
      for n = 1 : N
          if x_0(n) ^ 2 + y_0(m) ^ 2 < radius ^ 2
              disk(m, n) = exp( 1i * 2 * pi * rand(1, 1));
          end
      end
  end
  
  %进入RS算法之前的一次RS衍射， 方便输出
  U_in = U_i * disk;
  U_out = RS_(U_in, z, lamda, N, N, dx, dx);
  amplitude_out = abs(U_out);
  phase_out = U_out ./ amplitude_out;
  
  %下面是GS算法的循环过程
  U_down_i = phase_out .* amplitude_image; %带有down下标，都是下行RS衍射积分逆过程， up下标的是上行RS衍射积分正过程
  for j = 1 : 1 : cycle_index %循环次数
      
      tic
      U_down_o = RS_(U_down_i, z, -lamda, N, N, 0.3, 0.3);
      amplitude_down_o = abs(U_down_o);
      disk = U_down_o ./ amplitude_down_o;
  
      U_up_i = disk .* U_i;
      U_up_o = RS_(U_up_i, z, lamda, N, N, 0.3, 0.3);
      amplitude_up_o = abs(U_up_o);
      phase_up_o = U_up_o ./ amplitude_up_o;
      U_down_i = phase_up_o .* amplitude_image;
      
      toc
      
  end

  subplot(1, 2, 2);
  imshow(amplitude_up_o .^ 2);
  title('复原图片');
  