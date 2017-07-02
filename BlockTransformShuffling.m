%%%% main function of A scrabmling framwork for block transformation images
%%%%
%%%% Paper: A Scrambling Framework for Block Transform Compressed Images
%%%% Author: kazuki minemuea
%%%% Last update: 17th MAR 2015

%%%% work space configuration
clear all
close all
clc
addpath './lib';
addpath './minf';

Dataset = 'Standard';

% %%%% Get Directly Name
% Image_List = dir(['./input/',Dataset,'/*.tif']);
% %%%% Compression part
% for Image_index=1:1:length(Image_List)
%     name_cur = Image_List(Image_index).name;%%% aaaa.tif
%     input_dir = ['./input/',Dataset,'/'];
%     output_dir = ['./compress/',Dataset,'/'];
%     name_in = [input_dir,name_cur];
% 
%     if ~exist(output_dir)
%         mkdir(output_dir)
%     end
% 
%     %%%% Compression
%     for QF=75:5:75
%         %./image/aaa/image_0001
%         IMG = imread(name_in);
%         %%% Gray Scalegimage
%         if ismatrix(IMG)==0
%             IMG_gray = rgb2gray(IMG);
%         else
%             IMG_gray = IMG;
%         end
%         name_out = [output_dir,name_cur(1:length(name_cur)-4), '_',num2str(QF),'.jpg'];
%         imwrite(IMG_gray,name_out,'Quality',QF);
%     end
% end


fileID = fopen('Statistical_analysis.csv','w');
fileID2 = fopen('Image_quality.csv','w');

%%%% Get Directly Name
Image_List = dir(['./compress/',Dataset,'/*.jpg']);

fprintf(fileID2, 'name, SSIM, PSNR\n');
%%%% Scrambling part
for Image_index=1:1:1%length(Image_List)
    initial_flag = 0;
    name_cur = Image_List(Image_index).name;%%% aaaa.tif
    input_dir = ['./compress/',Dataset,'/'];
    output_dir = ['./output/',Dataset,'/'];
    if ~exist(output_dir)
        mkdir(output_dir)
    end
    
    for QF=75:5:75
        for repitition=1:1
            name_in = [input_dir,name_cur(1:length(name_cur)-4),'.jpg'];
            disp(name_in);
            %imshow(name_in);
            
            repitition = 1489571690;
            
            %%% load coefficients and headers
            %%% header
            handler = jpeg_read(name_in);
            %%% Quantize
            %QT = handler.quant_tables{1};
            %QT(:,:) = 255;
            
            %%% DCT coefficients
            C_ArrayInput = handler.coef_arrays{1};
            imshow(C_ArrayInput)
            %C_ArrayOutput = handler.coef_arrays{1};
            %[M,N]=size(C_ArrayInput);
            %M8 = floor(M/8);
            %N8 = floor(N/8);
            
            %%%% DC Processing
            %DC_Processing;
            
            %%%% AC Processing
            %AC_Processing;
            
            
            %%%% Evaluating Processing
            % Write image
            name_out = [output_dir,name_cur(1:length(name_cur)-4), '_',num2str(QF),'_',num2str(repitition),'.jpg'];
            %handler.quant_tables{1} = QT;
            %handler.coef_arrays{1} = C_ArrayOutput;
            
            %imshow(C_ArrayOutput);
            
            jpeg_write(handler, name_out)
            % SSIM
            A = imread(name_in);
            B = imread(name_out);
            SSIM = ssim_index(A,B);
            PSNR = psnr(A,B);
            
            % Bitstream Size
            s1 = dir(name_in);
            s2 = dir(name_out);
            BYTE = s2.bytes - s1.bytes;
            Percent = (BYTE*100)  / s1.bytes;
%             %             disp(Percent);
%             % Information entropy of grayscale
%             E_out = entropy(B);
%             
%             % Cross correlation
%             B_ref = B(1:end-1,1:end-1);
%             B_hor = B(1:end-1,2:end);
%             B_ver = B(2:end,1:end-1);
%             B_dia = B(2:end,2:end);
%             Cb_hor = corr2(B_ref,B_hor);
%             Cb_ver = corr2(B_ref,B_ver);
%             Cb_dia = corr2(B_ref,B_dia);
%             
%             if initial_flag == 0
%                 E_in = entropy(A);
%                 A_ref = A(1:end-1,1:end-1);
%                 A_hor = A(1:end-1,2:end);
%                 A_ver = A(2:end,1:end-1);
%                 A_dia = A(2:end,2:end);
%                 Ca_hor = corr2(A_ref,A_hor);
%                 Ca_ver = corr2(A_ref,A_ver);
%                 Ca_dia = corr2(A_ref,A_dia);
%                 
%                 % Joint entropy
%                 E_join = Mutual_info(A,A);
%                 % Mutual information
% %                 E_mu = E_in + E_in - E_join;
%                 E_mu = mi(A,A);
%       
%                 fprintf(fileID, 'name, entropy, mutual infromation, horizontal, vertiacal, diagonal\n');
%                 fprintf(fileID, '%s, %.4f, %.4f, %.4f, %.4f, %.4f\n', ...
%                     name_cur(1:length(name_cur)-4), E_in, E_mu, Ca_hor, Ca_ver, Ca_dia);
%                 initial_flag = 1;
%             end
%             
%             % Joint entropy
% %             E_join = Mutual_info(A,B);
%             % Mutual information
% %             E_mu = E_in + E_out - E_join;
%             E_mu = mi(A,B);
%             
%             fprintf(fileID, '%s, %.4f, %.4f, %.4f, %.4f, %.4f\n', ...
%                 num2str(QF), E_out, E_mu, Cb_hor, Cb_ver, Cb_dia);
            
                                    fprintf(fileID2, '%s, %.4f, %.4f, %.4f\n', ...
                name_cur(1:length(name_cur)-4), SSIM, PSNR,Percent);
        end % interlation
    end% quality factor
end
fclose(fileID);

