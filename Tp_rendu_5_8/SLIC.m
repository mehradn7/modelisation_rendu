clear;
close all;

% nb_images = 36; % Nombre d'images
% 
% % chargement des images
% for i = 1:nb_images
%     if i<=10
%         nom = sprintf('images/viff.00%d.ppm',i-1);
%     else
%         nom = sprintf('images/viff.0%d.ppm',i-1);
%     end
%     % L'ensemble des images de taille : nb_lignes x nb_colonnes x nb_canaux
%     % x nb_images
%     im(:,:,:,i) = imread(nom); 
% end

%% Segmentation SLIC

im1 = imread('images/viff.001.ppm');
[nb_lignes, nb_colonnes, nb_canaux] = size(im1);

% Placement des germes
N = nb_lignes*nb_colonnes;
K = 100;
S = floor(sqrt(N/K));

[X,Y] = meshgrid(floor(S/2):S:nb_lignes,floor(S/2):S:nb_colonnes);



im1_lab = rgb2lab(im1);
im1_l = im1_lab(:,:,1);
im1_l_grille = im1_l(sub2ind(size(im1_l),X,Y));
im1_a = im1_lab(:,:,2);
im1_a_grille = im1_a(sub2ind(size(im1_a),X,Y));
im1_b = im1_lab(:,:,3);
im1_b_grille = im1_b(sub2ind(size(im1_b),X,Y));

C = zeros(size(X,1)*size(X,2),5);
C(:,1) = im1_l_grille(:);
C(:,2) = im1_a_grille(:);
C(:,3) = im1_b_grille(:);
C(:,4) = X(:);
C(:,5) = Y(:);

figure; 
hold on
imshow(im1); title('Image 1');
plot(C(:,4),C(:,5),'+ r');



% Affinement de la grille

n=3;

% calcul des superpixels par k-moyenne
m=10;
seuil = 10;
cond = true;
P = [im1_l(:), im1_a(:), im1_b(:)];

while cond
    newC = zeros(size(C));
    for k=1:length(P)
        [x_p,y_p] = ind2sub(size(im1_l),k);
        ind_voisin_x = find(abs(C(:,4)-x_p)<=S);
        ind_voisin_y = find(abs(C(:,5)-y_p)<=S);
        ind_voisin = intersect(ind_voisin_x, ind_voisin_y);
        C_voisin = C(ind_voisin,:);
        
        D = dist_SLIC(C_voisin,[P(k,:) ,x_p, y_p],m,S);
        
        [min_D, i_min_D] = min(D);
        i_newC_p = ind_voisin(i_min_D);
        
        if all(newC(i_newC_p,:)==0)
            newC(i_newC_p,:) = [P(k,:) ,x_p, y_p];
        
        else
            newC(i_newC_p,:) = mean([P(k,:) ,x_p, y_p ; newC(i_newC_p,:)],1);
        
        end   
    end
    
    E = mean(sqrt(sum((C-newC).^2,2)))
    C = newC;
    cond = E>seuil;
end






    
 



