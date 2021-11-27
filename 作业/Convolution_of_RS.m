% ���������Բ�θ�˹�������䵽λ�� �������� Բ�̲��������估��������
close all;clear all;
w = 0.25;                    % ����������������뾶Ϊ0.25mm
lamda = 0.632e-3;           % ���伤�Ⲩ��
k = 2*pi/lamda;             % ����
q = 1i*pi*w^2/lamda;        % ��������q����
N = 500;                    % ��ǿ��������
x = linspace(-0.5,0.5,N);   % �۲��ߵ����귶Χ
z = 10;                     % ���䴫���ľ���
E0 = exp(-1i*k*x.^2/2/q);   % �������Ĺⳡ������ֲ�

[X Y] = meshgrid(x,x);      % ��������
[Ex Ey] =meshgrid(E0,E0);   % �ⳡ��ά��
E1 = Ex.*Ey;                % �������Ķ�ά�ⳡ
figure;imagesc(abs(E1).^2); % Բ�θ�˹����
colormap hot;axis image;

Disk = ones(N);     % ����뾶Ϊ0.1mm�ĵ���Բ��
for m = 1:N
    for n = 1:N
        if sqrt(x(m)^2+x(n)^2) <= 0.1
            Disk(m,n) = 0;
        end
    end
end

Ein = E1.*Disk;         % ͸��Բ�̵ĸ����
R = sqrt(z^2+X.^2+Y.^2);    % ���䴫���ռ����
coef = z./(2*pi*R) .*(1i*k -1./R) .*exp(-1i*k*R);   % ������ĩ������ϵ��
%% ����ܳ������CPU�ĺ�����Ŀ���ӿ�����ά�����
tic
Eout = conv2(coef,Ein,'same');  % ����Ķ�ά������㣬�õ���������
toc
%% ����ܳ������CPU�ĺ�����Ŀ���ӿ�����ά�����

Iout = abs(Eout).^2;            % �����ǿ
figure(1);imagesc(x,x,Iout);colormap hot;axis image off;
figure(2);mesh(Iout);view(0,82);colormap hot;axis off
