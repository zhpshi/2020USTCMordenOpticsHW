u_1 = 1; %圆孔处的光场，平行光
k = (2 * pi) / 0.5;
x_1;
y_1;
F = FFT (u_1 * exp( 1i * k * ( x_1 ^ 2 + x_2 ^ 2)));
display(F);

