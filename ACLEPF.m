%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo of "Active contour driven by local energy-based signed pressure 
% force for image segmentation" submiting to Pattern Recognition
% Huaxiang Liu
% East China University of Technology&&Central South University, Changsha, 
% China
% 18th, Dec, 2019
% Email: felicia_liu@126.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [u,e1,e2] = ACLEPF(Img,u, K,sigma,position)

%%%----computing the gradient of the------------------------------------%%%
   [ux, uy] = gradient(u);    
    Hu=0.5*(1+(2/pi)*atan(u./sigma));    
    DiracU = Dirac(u,sigma);      
    Ku = curvature_central(u);

    [f1, f2] = computelocalregion(Img, K, Hu);
    [f1, f2] = changepixel(f1, f2, position);
    
    
    e1=Img.*Img.*imfilter(ones(size(Img)),K,'replicate')-2.*Img.*imfilter(f1,K,'replicate')+imfilter(f1.^2,K,'replicate');
    e2=Img.*Img.*imfilter(ones(size(Img)),K,'replicate')-2.*Img.*imfilter(f2,K,'replicate')+imfilter(f2.^2,K,'replicate');
    
    dataForce = e2-e1;   

    mu = 6.5;
    penalizeTerm = mu*(4*del2(u)-Ku);
    lengthTerm = DiracU.*Ku;
    s= sqrt(ux.^2 + uy.^2);
    
%     u = u + 0.1*(sqrt(ux.^2 + uy.^2).*dataForce);
    u = u + 0.1*(s.*dataForce+penalizeTerm+lengthTerm);
    u = (u >= 0) - ( u< 0);
    G = fspecial('gaussian', 15, 1.5);
    u = conv2(u, G, 'same');

function f = Dirac(x, sigma)
f=(1/2/sigma)*(1+cos(pi*x/sigma));
b = (x<=sigma) & (x>=-sigma);
f = f.*b;

function k = curvature_central(u)
% compute curvature for u with central difference scheme
[ux,uy] = gradient(u);
normDu = sqrt(ux.^2+uy.^2+1e-10);
Nx = ux./normDu;
Ny = uy./normDu;
[nxx,junk] = gradient(Nx);
[junk,nyy] = gradient(Ny);
k = nxx+nyy;

function [f1,f2]=changepixel(f1,f2,position)
if position==0
    f1=min(f1,f2);
    f2=max(f1,f2);
end
if position==1
    f1=max(f1,f2);
    f2=min(f1,f2);
end


