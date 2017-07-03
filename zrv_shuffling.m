%% Zl_Scramble

function C_ArrayOutput = ZRV_Scrambling(C_ArrayOutput, MX, MY, repitition);

BlockAC_ZL = 64;

%%% scan order
ZigZag = [
    1     2     9     17    10    3      4     11 ...
    18    25    33    26    19    12     5     6 ...
    13    20    27    34    41    49    42    35 ...
    28    21    14    7     8     15    22    29 ...
    36    43    50    57    58    51    44    37 ...
    30    23    16    24    31    38    45    52 ...
    59    60    53    46    39    32    40    47 ...
    54    61    62    55    48    56    63    64 ...
    ];

MX8 = floor(MX/8);
MY8 = floor(MY/8);


for h=1:1:MX8
    for w=1:1:MY8
        x0 = (h - 1) * 8 + 1;
        y0 = (w - 1) * 8 + 1;
        CurrentBlock = zeros(MX,MY);
        CurrentBlockOne = zeros(64);
        CurrentBlock = C_ArrayOutput(x0:x0+7, y0:y0+7);
        
        for x=1:1:8 %%% Make One Dimension Array
            for y=1:1:8
                CurrentBlockOne((x-1)*8+y) = CurrentBlock(x,y);
            end
        end
        
        %%% EBSNZC
        EBSNZC_number=1;
        for n=1:1:64
            if CurrentBlockOne(n) ~= 0
                EBSNZC_number = EBSNZC_number+1;
            end
        end
        CurrentBlockMod = zeros(EBSNZC_number,2);
        
        %%% make Zerorun-Levele
        Zerorun = 0;
        current_index=1;
        DC = CurrentBlockOne(1);
        for n=2:1:64
            if CurrentBlockOne(ZigZag(n)) == 0
                Zerorun = Zerorun + 1;
            else
                CurrentBlockMod(current_index,1) = Zerorun;
                CurrentBlockMod(current_index,2) = CurrentBlockOne(ZigZag(n));
                Zerorun = 0;
                current_index = current_index + 1;
            end
        end
        
        %%% shuffle Zerorun-Level
        RL_partnumber = current_index-1;
        
        
        rand('state',repitition);
        scramble_key1=zeros(RL_partnumber);
        
        
        if RL_partnumber > BlockAC_ZL %%% ??a?p????[?^?[????????
            scramble_key1 = randperm(BlockAC_ZL) + RL_partnumber - BlockAC_ZL;
            for n=1:1:BlockAC_ZL %%% scramble ZL pair
                temp_zerorun(n) = CurrentBlockMod(scramble_key1(n),1);
                temp_level(n) = CurrentBlockMod(scramble_key1(n),2);
            end
            for n=1:1:BlockAC_ZL %%% subsititution Mod ZL pair
                CurrentBlockMod(n+RL_partnumber - BlockAC_ZL,1) = temp_zerorun(n);
                CurrentBlockMod(n+RL_partnumber - BlockAC_ZL,2) = temp_level(n);
            end
        else              %%% ??a?p????[?^?[??????????
            scramble_key1 = randperm(RL_partnumber);
            for n=1:1:RL_partnumber %%% scramble ZL pair
                temp_zerorun(n) = CurrentBlockMod(scramble_key1(n),1);
                temp_level(n) = CurrentBlockMod(scramble_key1(n),2);
            end
            for n=1:1:RL_partnumber %%% subsititution Mod ZL pair
                CurrentBlockMod(n,1) = temp_zerorun(n);
                CurrentBlockMod(n,2) = temp_level(n);
            end
        end
        
        %%% Zerorun-Level to one block
        CurrentBlockOne = zeros(64);
        current_index=2;
        CurrentBlockOne(1) = DC;
        for n=1:1:RL_partnumber
            current_index = current_index + CurrentBlockMod(n,1);
            CurrentBlockOne(ZigZag(current_index)) = CurrentBlockMod(n,2);
            current_index = current_index + 1;
        end
        
        for x=1:1:8 %%% Make Two Dimension Array
            for y=1:1:8
                CurrentBlock(x,y) = CurrentBlockOne((x-1)*8+y);
            end
        end
        C_ArrayOutput(x0:x0+7, y0:y0+7) = CurrentBlock;
    end
end