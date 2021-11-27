clear all;clc;
cm = 1e-2;
mm = 1e-3;
um = 1e-6;
nm = 1e-9;%单位准备部分%

Lamda=638*nm;
M=512; N=512;
dx=10.0*um; dy=10.0*um; 


x = linspace(-255,256,N);   % 衍射屏和观察屏
screen = zeros(M,N);      % 狭缝
[m,n]=meshgrid(x);
l=30 ;h=50;
a=10;
D=find((abs(m)<=l)&(abs(n)<=h)&(abs(m)>=a));
screen(D) = 1;  % 长为2h，高为l的矩形
figure,imshow(screen,[]);

 for Dist=5*cm:1*cm:7*cm
x=linspace(-M*dx/2,(M-1)*dx/2,N);
y=linspace(-N*dy/2,(N-1)*dy/2,M);
[x,y]=meshgrid(x,y);
SphFunct=exp(i*pi*(x.^2+y.^2)/(Lamda*Dist)); 

Screen_F=fftshift(fft2(fftshift(screen))); %Fourier transform of the slit function.
SphFunct_F=fftshift(fft2(fftshift(SphFunct))); %Fourier transform of the spherical function.
FresnelDiffract=fftshift(ifft2(fftshift(Screen_F.*SphFunct_F))); % Inverse Fourier transform

FresnelDiffract_I=FresnelDiffract.*conj(FresnelDiffract); 
figure,imshow(FresnelDiffract_I,[]);
 end