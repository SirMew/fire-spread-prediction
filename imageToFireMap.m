function map = imageToFireMap(fileName)

A = imread(fileName);
a1 = A(:,:,1);

B_idx = (a1==237); %where red set to fire
correction_idx = (a1~=237 & a1~=34 & a1 ~= 127); %detects any colours that may have occurred due to automatic blending in paint
F_idx = (a1==34); %where green set to fuel
O_idx = (a1==127); %where grey set to out

map = zeros(1000,1000);
map(B_idx) = 3;
map(F_idx) = 2;
map(O_idx) = 1;
map(correction_idx) = 2; 