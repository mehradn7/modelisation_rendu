% Segmentation binaire
load SLIC;
seuil_L = 57;
seuil_a = 18.9;
seuil_b = 0;
ind_seuil_C_L = find(C(:,1) > seuil_L);
ind_seuil_C_a = find(C(:,2) > seuil_a);
ind_seuil_C_b = find(C(:,3) > seuil_b);
ind_seuil_C = [ind_seuil_C_L; ind_seuil_C_a; ind_seuil_C_b];
im_seuil = ismember(super_pixels,ind_seuil_C);
im_seuil = reshape(im_seuil,[size(im1,1), size(im1,2)]);



imshow(im_seuil);