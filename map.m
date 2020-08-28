function Ir = Map(I,L,So)

%% feature map
Ir        = zeros(size(I(:,:,1)));            % Feature Map Images
[m, n, v] = find(So == 1);                    % So locations
for i = 1:sum(v)
  Ir(m(i),n(i)) = L(I(m(i), n(i), 1), I(m(i), n(i), 2), I(m(i), n(i), 3));
end

end
