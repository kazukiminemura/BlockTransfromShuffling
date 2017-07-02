function [C_array] = dc_process(C_arrayInput, shufParam)
% ------------------------------------------
% DC Processoings
% Copyright (c) 2017 Kazuki Minemura
% Written by kazuki minemuea
% Last update: 1st July 2017
% ------------------------------------------

[M,N]=size(C_arrayInput);
M8 = floor(M/8);
N8 = floor(N/8);

% Reartranging DC component
% Divide them into DC's and AC's
% 1-1-1 Extract DC component
DC = C_arrayInput(1:8:M,1:8:N);

% 1-1-2 Extract energy of AC block (EAC)
C_arrayComplexity = zeros(M,N);
for m=1:8:M
    for n=1:8:N
        blk = zeros(8,8);
        blk(:,:) = C_arrayInput(m:m+7,n:n+7);
        blk(1,1) = 0;
        eac_m = 1 + floor(m/8);
        eac_n = 1 + floor(n/8);
        EAC(eac_m,eac_n)=sum(sum(abs(blk)));
    end
end

% 1-1-3 normalization
eac_avg= mean(mean(EAC));
C_arrayComplexity = cast(EAC*255/eac_avg,'uint8');

% 1-2 AC power labelig
% binary image by Otsu method
b_binary = im2bw(C_arrayComplexity,graythresh(C_arrayComplexity));
b_binary = ~b_binary;
b_binary = bwmorph(b_binary, 'clean');
% Labeling DC coefficients 
label = bwlabel(b_binary,4);
% rearrange DC coefficients
RDC = dc_rearranging(DC,M8,N8,label,shufParam);
C_arrayInput(1:8:M,1:8:N) = RDC(:,:);

% 1-3 DC prediction error mapping
C_array = dc_error_mapping(C_arrayInput,shufParam);