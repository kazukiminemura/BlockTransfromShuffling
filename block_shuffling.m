% ------------------------------------------
% block shuffling
% Copyright (c) 2017 Kazuki Minemura
% Written by kazuki minemuea
% ------------------------------------------
function C_ArrayOutput = block_shuffling(C_ArrayInput, MX, MY, shufParam)
%%% Block_Scramble

MX8 = floor(MX/8);
MY8 = floor(MY/8);


%% 2-1 AC block scramble
C_ArrayOutput = zeros(MX8,MY8);
AC_puudding = zeros(MX8*MY8,64);
AC_puudding_new = zeros(MX8*MY8,64);

rand('state',shufParam);
scramble_key1 = randperm(MX8*MY8);


%%% Save DC
C_Array_DC_power(:,:) = C_ArrayInput(1:8:end, 1:8:end);

%%% SCrambling Block of AC
for n=1:1:MX8
    for m=1:1:MY8
        for x=1:8
            for y=1:8
                AC_puudding((n-1)*MY8 + m, (x-1)*8+y ) = ...
                    C_ArrayInput((n-1)*8 + x,(m-1)*8 + y);
            end
        end
    end
end
%%% Suffuling
for n=1:1:MX8*MY8
    for x=1:8
        for y=1:8
            AC_puudding_new(scramble_key1(n), (x-1)*8+y) = AC_puudding(n, (x-1)*8+y);
        end
    end
end
%%% Restore
for n=1:1:MX8*MY8
    for x=1:8
        for y=1:8
            AC_puudding(n, (x-1)*8+y) = AC_puudding_new(n, (x-1)*8+y);
        end
    end
end
%%% Output Processing
for n=1:1:MX8
    for m=1:1:MY8
        for x=1:8
            for y=1:8
                C_ArrayOutput((n-1)*8 + x,(m-1)*8 + y) = ...
                    AC_puudding((n-1)*MY8 + m, (x-1)*8+y);
            end
        end
    end
end

%% Insert DC
C_ArrayOutput(1:8:end, 1:8:end) = C_Array_DC_power(:,:);

end