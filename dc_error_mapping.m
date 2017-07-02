function outputArray = dc_error_mapping(inputArray,shufParam)
% ------------------------------------------
% dc_error_mapping
% Copyright (c) 2017 Kazuki Minemura
% Written by kazuki minemuea
% Last update: 1st July 2017
% ------------------------------------------

[M,N] = size(inputArray);
outputArray = inputArray;
M8 = floor(M/8);
N8 = floor(N/8);

DC = inputArray(1:8:M,1:8:N);
DC_err = zeros(M8,N8);
DC_mod = zeros(M8,N8);

%%%% Extract DC Error
for m=1:M8
    for n=1:N8
        if m==1&&n==1
            DC_err(m,n) = DC(m,n);
            DC_pre = DC(m,n);
        else
            % subtract last DC
            DC_err(m,n) = DC(m,n) - DC_pre;
            DC_pre = DC(m,n);
        end        
    end
end

%%%% DC prediction error scrambling
for m=1:M8
    for n=1:N8        
        if n>1
            if(abs(DC_err(m,n))>1)
                start_point = power(2,floor(log2(abs(DC_err(m,n))))-1);
                end_point = power(2,floor(log2(abs(DC_err(m,n)))))-1;
                r = randi([start_point end_point],1,1);       
                R = abs(DC_err(m,n));
                if  DC_err(m,n)>0
                    DC_err(m,n) = bitxor(R,r);
                else
                    DC_err(m,n) = -bitxor(R,r);
                end
%                 if mod(randi(2,1,1),2) == 1
%                     DC_err(m,n) = DC_err(m,n);
%                 end
            end
        end        
    end
end



%% Restore DC
for m=1:1:M8
    for n=1:1:N8
        if m==1 && n==1
            DC_mod(m,n) = DC_err(m,n);
            DC_pre = DC_mod(m,n);
        else
            % subtract last DC
            DC_mod(m,n) = DC_err(m,n) + DC_pre;
            DC_pre = DC_mod(m,n);
        end  
    end
end

outputArray(1:8:M,1:8:N) = DC_mod(:,:);

end