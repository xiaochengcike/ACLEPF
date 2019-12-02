%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo of "Active contour driven by local energy-based signed pressure 
% force for image segmentation" submiting to Pattern Recognition
% Huaxiang Liu
% East China University of Technology&&Central South University, Changsha, 
% China
% 18th, Dec, 2019
% Email: felicia_liu@126.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;close all;

addpath 'image';
ImgID = 1;
Img = imread([num2str(ImgID),'.bmp']);


I=Img;
[row,col,K] = size(Img);

if K>1
    Img = rgb2gray(Img);
end

K = fspecial('gaussian',1, 1.5);
Img = imfilter(Img,K,'replicate');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rad = adaptivescale(min,max)
% min: the minimal value of the local window size 
% min: the maximum value of the local window size 
% Img: the input image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigma = adaptivescale(3,15,Img);

%%%----Inintial contour curve-------------------------------------------%%%
phi = ones(size(Img(:,:,1))).*2;

%%%----parameters settings----------------------------------------------%%%

switch ImgID
    case 1
        phi(19:56,51:62) = -2;
        position = 0;% 0: the intensity value in the object region is 
    case 2
        phi(30:65,20:70) = -2;
        position = 0;
    case 3
        phi(29:36,51:62) = -2;
        position = 0;
    case 4        
        phi(19:26,51:62) = -2;
        position = 0;
    case 5        
        phi(80:120,80:140) = -2;
        position = 1;
    case 6        
        phi(29:36,51:62) = -2;
        position = 0;
    case 7        
        phi(29:36,51:62) = -2;
        position = 0;
    case 8
        phi(19:26,51:62) = -2;
        position = 0; 
    otherwise
        phi(1:10,1:10) = -2;
        position = 0;
end
u = phi;
figure,subplot(1,2,1);
imshow(I,[0 255]);
hold on;
[c, h] = contour(u, [0 0], 'r');
title('Initial contour');
hold off;
Img = double(Img);
Ksigma = fspecial('gaussian', round(2*sigma)*2+1, sigma);

IterNum = 100;
mu = 10;
epsilon =1.5;
lambda1 = 1;
lambda2 = 1;

subplot(1,2,2);

for i=1:IterNum
    [u,e1,e2] = ACLEPF(Img,u, Ksigma,epsilon,position);
    if mod(i,10)==0
        pause(0.1);
        imshow(I, [0, 255]);colormap(gray);hold on;axis off,axis equal%imagesc
        [c,h] = contour(u,[0 0],'r');
        iterNum=[num2str(i), ' iterations'];
        title(iterNum);
        hold off;
    end
end
imshow(I,[0 255]);colormap(gray);hold on;
[c, h] = contour(u, [0 0], 'g');



    
