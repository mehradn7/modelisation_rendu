function D = dist_SLIC( C, P, m,S)

Dlab = sqrt(sum((C(:,1:3)-P(:,1:3)).^2,2));
Dxy = sqrt(sum((C(:,4:5)-P(:,4:5)).^2,2));
D = Dlab + (m/S)*Dxy;

end

