% ------------------------------------------
% Block Transform Shuffling
% Copyright (c) 2017 Kazuki Minemura
% Written by kazuki minemuea
% ------------------------------------------

% work space configuration
clear variables; close all; clc
% add jpeg library: you may need to compile jpeg libaray on your enviroment
addpath './lib';


% shuffling parameter
shufParam = 1489571690;

%read DCT coefficients and header
handler = jpeg_read('Lenna.jpg');

% change quantization values to 255
%QT = handler.quant_tables{1};
%QT(:,:) = 255;

% extract DCT coefficients
c_arrayInput = handler.coef_arrays{1};

%C_ArrayOutput = handler.coef_arrays{1};
%[M,N]=size(C_ArrayInput);
%M8 = floor(M/8);
%N8 = floor(N/8);

%% DC Processing
c_array = dc_process(c_arrayInput, shufParam);

%% AC Processing
c_array = ac_processing(c_array, shufParam);

%% Write shuffled image
handler.coef_arrays{1} = c_array;
%imshow(c_array);
jpeg_write(handler, 'Shuffled.jpg')