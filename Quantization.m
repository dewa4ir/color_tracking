function I = Quantization(img, Bin)

Q   = 256/Bin;                                      % Quantization Step
I   = (floor(double(img)/Q))+1;                     % Indexed Image [1~Bin]

end
