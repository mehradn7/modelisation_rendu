function [ VX1,VX2,VY1,VY2] = clean_voronoi( VX, VY, nb_lignes, nb_colonnes )
% Permet de seulement garder les sommets de Voronoï situé à l'intérieur de
% l'image

VX1 = VX(1,:);
VX2 = VX(2,:);
VY1 = VY(1,:);
VY2 = VY(2,:);
ind_x = VX1 >= 1;
VX1 = VX1(ind_x);
VX2 = VX2(ind_x);
VY1 = VY1(ind_x);
VY2 = VY2(ind_x);
ind_x = VX2 >= 1;
VX1 = VX1(ind_x);
VX2 = VX2(ind_x);
VY1 = VY1(ind_x);
VY2 = VY2(ind_x);
ind_x = VX1 <= nb_colonnes - 50;
VX1 = VX1(ind_x);
VX2 = VX2(ind_x);
VY1 = VY1(ind_x);
VY2 = VY2(ind_x);
ind_x = VX2 <= nb_colonnes - 50;
VX1 = VX1(ind_x);
VX2 = VX2(ind_x);
VY1 = VY1(ind_x);
VY2 = VY2(ind_x);
ind_y = VY1 >= 5;
VX1 = VX1(ind_y);
VX2 = VX2(ind_y);
VY1 = VY1(ind_y);
VY2 = VY2(ind_y);
ind_y = VY2 >= 5;
VX1 = VX1(ind_y);
VX2 = VX2(ind_y);
VY1 = VY1(ind_y);
VY2 = VY2(ind_y);
ind_y = VY1 <= nb_lignes;
VX1 = VX1(ind_y);
VX2 = VX2(ind_y);
VY1 = VY1(ind_y);
VY2 = VY2(ind_y);
ind_y = VY2 <= nb_lignes;
VX1 = VX1(ind_y);
VX2 = VX2(ind_y);
VY1 = VY1(ind_y);
VY2 = VY2(ind_y);

end

