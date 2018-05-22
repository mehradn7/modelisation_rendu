%% Estimation de l'axe médian
load mask;
%% Estimation de la FRONTIERE

im_mask_1 = 1 - im_mask(:,:,1);
[nb_lignes, nb_colonnes, nb_canaux] = size(im_mask_1);

% Calcul d'un point initial sur la frontière
i = 42; % choix de la ligne supervisé
j = 1;
while j<size(im_mask_1,2) && (im_mask_1(i,j) ~= 1)
    j=j+1;
end

if (im_mask_1(i,j) == 1)
   P_initial = [i, j];
end

B = bwtraceboundary(im_mask_1, P_initial, 'NW');
imshow(im_mask_1)
hold on
[VX_init, VY_init] = voronoi(B(:,2), B(:,1));
VX = VX_init(1,:);
VY = VY_init(1,:);
ind_x = VX >= 1;
VX = VX(ind_x);
VY = VY(ind_x);
ind_x = VX <= nb_colonnes - 50;
VX = VX(ind_x);
VY = VY(ind_x);
ind_y = VY >= 5;
VX = VX(ind_y);
VY = VY(ind_y);
ind_y = VY <= nb_lignes;
VX = VX(ind_y);
VY = VY(ind_y);

Px = round(VX);
Py = round(VY);
ind_int = [];
for k=1:length(Px)
    if im_mask_1(Py(k),Px(k)) == 1
        ind_int = [ind_int, k];
    end
end

VX = VX(ind_int);
VY = VY(ind_int);
rayons = zeros(length(VX), 1);

for k=1:length(VX)
    distances_frontiere = sqrt((VX(k) - B(:,2)).^2 + (VY(k) - B(:,1)).^2);
    [rayon, ~] = min(distances_frontiere);
    rayons(k) = rayon;
end

rayon_min_souhaite = 5;
indices_rayons_a_garder = find(rayons > rayon_min_souhaite);
VX = VX(indices_rayons_a_garder);
VY = VY(indices_rayons_a_garder);
rayons = rayons(indices_rayons_a_garder);


TRI = delaunay(B(:,2), B(:,1));


plot(VX, VY, '*b')
plot(B(:,2), B(:,1), 'g');

