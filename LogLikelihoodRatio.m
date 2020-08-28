function SD = LogLikelihoodRatio(I, Si, Sb, Bin)

%% compute log liklihood ratio
[m, n, v] = find(Si == 1);                              % Si locations
Hi    = zeros(Bin, Bin, Bin);                           % HISTOGRAM-I
for i = 1:sum(v)
  Hi(I(m(i), n(i), 1), I(m(i), n(i), 2), I(m(i), n(i), 3)) = Hi(I(m(i), n(i), 1), I(m(i), n(i), 2), I(m(i), n(i), 3)) + 1;
end
[m, n, v] = find(Sb == 1);                              % Sb locations
Hb    = zeros(Bin, Bin, Bin);                           % HISTOGRAM-B

for i = 1:sum(v)
  Hb(I(m(i), n(i), 1), I(m(i), n(i), 2), I(m(i), n(i), 3)) = Hb(I(m(i), n(i), 1), I(m(i), n(i), 2), I(m(i), n(i), 3)) + 1;
end

Hi(Hi==0) = 1; Hb(Hb==0) = 1;                         % Epsilon
L     = log(Hi./Hb);                                  % Log - Liklihood Ratio
L     = L.*(L > 0);                                   % Remove Negative Values
L     = (L - min(L(:)))/(max(L(:)) - min(L(:)));      % Normalize
SD    = L > 0.5;                                      % Object Color Seeds

end
