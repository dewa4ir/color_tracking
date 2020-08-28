function ac = avcol(img, M)

R  = img(:,:,1); R = mean(double(R(imbinarize(M))));
G  = img(:,:,2); G = mean(double(G(imbinarize(M))));
B  = img(:,:,3); B = mean(double(B(imbinarize(M))));
ac = (R + G + B)/3;

end
