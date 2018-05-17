clear;
close all;

nb_images = 36; % Nombre d'images

% chargement des images
for i = 1:nb_images
    if i<=10
        nom = sprintf('images/viff.00%d.ppm',i-1);
    else
        nom = sprintf('images/viff.0%d.ppm',i-1);
    end
    % L'ensemble des images de taille : nb_lignes x nb_colonnes x nb_canaux
    % x nb_images
    im(:,:,:,i) = imread(nom); 
end

%% Segmentation SLIC

im1 = im(:,:,:,1);
[nb_lignes, nb_colonnes, nb_canaux] = size(im1);

% Placement des germes
N = nb_lignes*nb_colonnes;
K = 100;
S = floor(sqrt(N/K));

[X,Y] = meshgrid(floor(S/2):S:nb_lignes,floor(S/2):S:nb_colonnes);



im1_lab = rgb2lab(im1);
im1_l = im1_lab(:,:,1);
im1_a = im1_lab(:,:,2);
im1_b = im1_lab(:,:,3);

C = zeros(size(X,1),size(X,2),5);
C(:,:,1) = im1_l(sub2ind(size(im1_l),X,Y));
C(:,:,2) = im1_a(sub2ind(size(im1_a),X,Y));
C(:,:,3) = im1_b(sub2ind(size(im1_b),X,Y));
C(:,:,4) = X;
C(:,:,5) = Y;


% Affinement de la grille

n=3;


%










