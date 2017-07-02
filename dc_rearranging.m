function RDC = dc_rearranging(DC,M8,N8,label,shufParam)
% ------------------------------------------
% Rearranging DC
% Copyright (c) 2017 Kazuki Minemura
% Written by kazuki minemuea
% Last update: 1st July 2017
% ------------------------------------------

% reshape dimension 2D to 1D
DC_1D = reshape(DC,[M8*N8,1]);

% 1-4-2 Reindexing label
% extract segment information
label_max = 0;
label_mod = zeros(M8,N8);

label_mod = label + 1;
label_max = max(max(label_mod));

% 3-3-4 forming DC groups
label_max =  max(max(label));
DC_bins = zeros([label_max,M8*N8]);
DC_bins_num = zeros([label_max,1]);

for k=1:1:label_max
    for m=1:M8
        if mod(m,2)==1
            for n=1:N8
                if label_mod(m,n) == k
                    DC_bins(k,DC_bins_num(k) + 1) = DC(m,n);
                    DC_bins_num(k) = DC_bins_num(k) + 1;
                end
            end
        else
            for n=N8:-1:1
                if label_mod(m,n) == k
                    DC_bins(k,DC_bins_num(k) + 1) = DC(m,n);
                    DC_bins_num(k) = DC_bins_num(k) + 1;
                end
            end
        end
    end
end

% DC_bins_num
% sum(DC_bins_num)

% 3-3-5-1 shuffle DC groups
RDC_1D = zeros(M8*M8);
rand('state',shufParam);
scramble_key = randperm(label_max);  
% Scramble
% RDC_index=1;
% for k=1:1:label_max
%     for b=1:1:DC_bins_num(scramble_key(k))
%         RDC_1D(RDC_index)=DC_bins(scramble_key_part(k),b);
%         RDC_index=RDC_index+1;
%     end
% end
% NoScramble ---- putting in ascendingg order of label index
RDC_index = 1;
for k=1:1:label_max
    for b=1:1:DC_bins_num(k)
        RDC_1D(RDC_index)=DC_bins(k,b);
        RDC_index=RDC_index+1;
    end
end

% 3-3-5 substitute DC power to Output array
RDC_index=1;
for m=1:1:M8
    for n=1:1:N8
        RDC(m,n) = RDC_1D(RDC_index);
        RDC_index=RDC_index+1;
    end
end
% OutputArray = InputArray;
% for n=1:1:MX
%     for m=1:1:MY
%         OutputArray((n-1)*8+1,(m-1)*8+1) = DC_pudding((n-1)*MY+m);
% %             OutputArray((n-1)*8+1,(m-1)*8+1) = 0;
%     end
% end

end