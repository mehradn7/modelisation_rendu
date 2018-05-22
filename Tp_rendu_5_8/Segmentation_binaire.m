% Segmentation binaire
load SLIC;
seuil_L = 57;
ind_seuil_C = find(C(:,1) > seuil_L);
im_seuil = ismember(super_pixels,ind_seuil_C);
im_seuil = reshape(im_seuil,[size(im1,1), size(im1,2)]);



imshow(im_seuil);