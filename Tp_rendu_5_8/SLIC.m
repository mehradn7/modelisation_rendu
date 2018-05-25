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
K = 200;
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

% Affichage de l'image et des germes
figure(1); 
title('Image 1');

imshow(im1);
hold on 
plot(C(:,5),C(:,4),'+ r');
hold off
drawnow nocallbacks


% Affinement de la grille

n=1;
im_gradient_L = imgradient(im1_l);
for k=1:size(C,1)
   im_gradient_k = im_gradient_L(max(C(k,4)-n,1):min(C(k,4)+n,nb_lignes),max(C(k,5)-n,1):min(C(k,5)+n,nb_colonnes));
   [~, i_min] = min(im_gradient_k(:));
   [x_min,y_min] = ind2sub(size(im_gradient_k), i_min);
   new_x = C(k,4) + x_min -n-1;
   new_y = C(k,5) + y_min -n-1;
   C(k,1) = im1_l(round(new_x),round(new_y));
   C(k,2) = im1_a(round(new_x),round(new_y));
   C(k,3) = im1_b(round(new_x),round(new_y));
   C(k,4) = new_x;
   C(k,5) = new_y;    
end

% Affichage de l'image et des germes affinées
figure(1); 
title('Image 1');

imshow(im1);
hold on 
plot(C(:,5),C(:,4),'+ r');
hold off
drawnow nocallbacks

% calcul des superpixels par k-moyenne
m=10;
seuil = 10;
cond = true;
P = [im1_l(:), im1_a(:), im1_b(:)];
nb_it=0;
while cond
    newC = zeros(size(C));
    super_pixels = zeros(length(P),1);
    for k=1:length(P)
        
        [x_p,y_p] = ind2sub(size(im1_l),k);
        
        ind_voisin = find(sqrt((C(:,4)-x_p).^2 + (C(:,5)-y_p).^2)<=2*S);
        C_voisin = C(ind_voisin,:);
        
        D = dist_SLIC(C_voisin,[P(k,:) ,x_p, y_p],m,S);
        
        [min_D, i_min_D] = min(D);
        i_newC_p = ind_voisin(i_min_D);
        
        super_pixels(k) = i_newC_p;  
        
    end
    for k_C=1:size(C,1)
        ind_P = find(super_pixels == k_C);
        [x_p,y_p] = ind2sub(size(im1_l),ind_P);
        newC(k_C,:) = mean([P(ind_P,:), x_p, y_p]);
    end
    
    
    E = sum(sqrt(sum((C-newC).^2,2)));
    C = newC;
    imshow(im1);
    hold on
    plot(C(:,5),C(:,4),'+ r');
    hold off
    
    cond = E>seuil;
    drawnow nocallbacks
    nb_it=nb_it+1;
end

save('SLIC','C','super_pixels','im1');




    
 



