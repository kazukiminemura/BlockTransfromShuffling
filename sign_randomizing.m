% ------------------------------------------
% sign radomizing
% Copyright (c) 2017 Kazuki Minemura
% Written by kazuki minemuea
% ------------------------------------------
function C_Array = sign_randomizing(C_ArrayInput,XSIZE, YSIZE, repitition)
%% Flip sing
rand('state',repitition);

randNum = rand(XSIZE,YSIZE);
theSign = (randNum >= 0.5) - 1 * (randNum < 0.5);


C_Array_DC_power(:,:) = C_ArrayInput(1:8:end, 1:8:end);

C_Array = zeros(XSIZE,YSIZE);
C_Array = C_ArrayInput .* theSign;
C_Array(1:8:end, 1:8:end) = C_Array_DC_power(:,:);

clear randNum theSign

end