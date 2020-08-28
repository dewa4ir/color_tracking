function [Si, Sb, So] = SearchArea(img, or)

d     = ceil((or(3)+or(4))*(0.25)*(sqrt(2)-1));        % Delta
sr(1) = or(1) - d;                                     % Left
sr(2) = or(2) - d;                                     % Up
sr(3) = or(3) + 2*d;                                   % Width
sr(4) = or(4) + 2*d;                                   % Height

Si = zeros(size(img, 1),size(img, 2));                   % logical indexing
So = zeros(size(img, 1), size(img, 2));
Si(or(2):or(2)+or(4), or(1):or(1)+or(3)) = 1;
So(sr(2):sr(2)+sr(4), sr(1):sr(1)+sr(3)) = 1;
Sb = So - Si;

end
