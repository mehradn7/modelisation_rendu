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

[VX_init, VY_init] = voronoi(B(1:10:end,2), B(1:10:end,1));

[ VX1,VX2,VY1,VY2] = clean_voronoi( VX_init, VY_init, nb_lignes, nb_colonnes );


Px = round(VX1);
Py = round(VY1);
ind_int = [];
for k=1:length(Px)
    if im_mask_1(Py(k),Px(k)) == 1
        ind_int = [ind_int, k];
    end
end

VX1 = VX1(ind_int);
VY1 = VY1(ind_int);
VX2 = VX2(ind_int);
VY2 = VY2(ind_int);
rayons = zeros(length(VX1), 1);

for k=1:length(VX1)
    distances_frontiere = sqrt((VX1(k) - B(:,2)).^2 + (VY1(k) - B(:,1)).^2);
    [rayon, ~] = min(distances_frontiere);
    rayons(k) = rayon;
end

% rayon_min_souhaite = 10;
% indices_rayons_a_garder = find(rayons > rayon_min_souhaite);
% VX1 = VX1(indices_rayons_a_garder);
% VX2 = VX2(indices_rayons_a_garder);
% VY1 = VY1(indices_rayons_a_garder);
% VY2 = VY2(indices_rayons_a_garder);
% rayons = rayons(indices_rayons_a_garder);


VX = [VX1; VX2];
VY = [VY1; VY2];

figure(1);
imshow(im_mask_1)
hold on
plot(VX, VY, 'b')
plot(B(:,2), B(:,1), 'g');
hold off;

figure(2);
imshow(im_mask_1)
hold on
viscircles([VX(1,:)'  VY(1,:)'],rayons,'LineWidth',0.01);


