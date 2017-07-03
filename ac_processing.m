% ------------------------------------------
% AC processing
% Copyright (c) 2017 Kazuki Minemura
% Written by kazuki minemuea
% ------------------------------------------
function c_Array = ac_processing(c_Array, shufParam)

[M,N]=size(c_Array);

% AC sign randomization
c_Array = sign_randomizing(c_Array,M,N,shufParam);

% AC ZRV pair shuffling
c_Array = zrv_shuffling(c_Array,M,N,shufParam);

% AC block shuffling
c_Array = block_shuffling(c_Array,M,N,shufParam);