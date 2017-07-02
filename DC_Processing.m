%%%% DC Processoings 
%%%%
%%%% Paper: A Scrambling Framework for Block Transform Compressed Images
%%%% Author: kazuki minemuea
%%%% Last update: 17th MAR 2015



%%%% Reartranging DC component
%%% Divide them into DC's and AC's
%%% 1-1-1 Extract DC component
DC = C_ArrayInput(1:8:M,1:8:N);
%%% 1-1-2 Extract energy of AC block (EAC)
C_Array_Complexity=zeros(M,N);
for m=1:8:M
    for n=1:8:N
        BLK8x8 = zeros(8,8);
        BLK(:,:) = C_ArrayInput(m:m+7,n:n+7);
        BLK(1,1) = 0;
        eac_m = 1 + floor(m/8);
        eac_n = 1 + floor(n/8);
        EAC(eac_m,eac_n)=sum(sum(abs(BLK)));
    end
end
%%% 1-1-3 normalization
eac_avg= mean(mean(EAC));
C_Array_Complexity = cast(EAC*255/eac_avg,'uint8');
%%% 1-2 AC power labelig
%%% binary image
b_binary = im2bw(C_Array_Complexity,graythresh(C_Array_Complexity));
b_binary = ~b_binary; %
b_binary = bwmorph(b_binary, 'clean');
%%% Main Labeling
Label = bwlabel(b_binary,4);
%%% Scrabmle DC
repitition = 1;
RDC = DC_Rearranging(DC,M8,N8,Label,repitition);
C_ArrayOutput(1:8:M,1:8:N) = RDC(:,:);


%%%% DC Prediction Error Scrambling
C_ArrayOutput = DC_Error_Scrambling(C_ArrayOutput,repitition);

%%%% DC Error Category Attack
% C_ArrayOutput = DC_Category_Attack(C_ArrayInput);