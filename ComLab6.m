%% (1) + (2) Image to Bit Conversion + QPSK Modulation 

clear all;
clc;

img=imread('PicOne1.jpg');
img=reshape(img,[],1).';
imgbit= de2bi(img,'left-msb').';
bitStream=reshape(imgbit,[],1); 

% Define 4 Symbols:

[S1,S2,S3,S4] = deal(3+3i, 3-3i ,-3-3j ,-3+3i); 

QPSK_Mod=[];

len=length(bitStream); %Number of Bits

%QPSK Modulator: 

for i=1:2:len
    if bitStream(i)==0 && bitStream(i+1) == 0     % '00'
        In_Quad= S1;
    
    elseif bitStream(i)==0 && bitStream(i+1) == 1 % '01'   
        In_Quad=S2;
    
    elseif bitStream(i)==1 && bitStream(i+1) == 0 % '10'
        In_Quad=S3;
    
    elseif bitStream(i)==1 && bitStream(i+1) == 1 %'11'
        In_Quad=S4;
    end
    
   
    QPSK_Mod=[QPSK_Mod,In_Quad]; %11532 modulated symbols
end

% Plot QPSK Constellation

scatterplot(QPSK_Mod,[],[],'*');grid minor; xlim([-6,6]);ylim([-6,6]);
title('QPSK Constellation - Zero Noise Channel');
yline(0,'LineWidth',2);xline(0,'LineWidth',2);

text(3,0,'|','Color','black','FontSize',12);
text(-3,0,'|','Color','black','FontSize',12);
text(0,3,'-','Color','black','FontSize',12);
text(0,-3,'-','Color','black','FontSize',12);

text(2.6,3.5,'00','Color','black','FontSize',12);
text(2.6,-2.1,'01','Color','black','FontSize',12);
text(-3.4,3.5,'11','Color','black','FontSize',12);
text(-3.4,-2.1,'10','Color','black','FontSize',12);
text(2.5,-0.5,'3','Color','red','FontSize',14);
text(-3.5,-0.5,'-3','Color','red','FontSize',14);
text(-0.5,3,'3j','Color','red','FontSize',14);
text(-0.5,-3,'-3j','Color','red','FontSize',14);

%% (3) Adding AWGN to Constellation  

Noisy_Mod5=awgn(QPSK_Mod,5,'Measured');  %  SNR = 5
Noisy_Mod8=awgn(QPSK_Mod,8,'Measured');  %  SNR = 8
Noisy_Mod15=awgn(QPSK_Mod,15,'Measured');%  SNR = 15
Noisy_Mod25=awgn(QPSK_Mod,25,'Measured');%  SNR=25

% Constellation Display: SNR = 5

scatterplot(Noisy_Mod5,4);title('Constellation - SNR = 5 ')
yline(0,'LineWidth',2);xline(0,'LineWidth',2);

text(3,0,'|','Color','black','FontSize',12);
text(-3,0,'|','Color','black','FontSize',12);
text(0,3,'-','Color','black','FontSize',12);
text(0,-3,'-','Color','black','FontSize',12);
text(3,-0.5,'3','Color','red','FontSize',14);
text(-3,-0.5,'-3','Color','red','FontSize',14);
text(-0.5,3,'3j','Color','red','FontSize',14);
text(-0.5,-3,'-3j','Color','red','FontSize',14);

% Constellation Display: SNR = 8

scatterplot(Noisy_Mod8,4);title('Constellation - SNR = 8 ')
yline(0,'LineWidth',2);xline(0,'LineWidth',2);

text(3,0,'|','Color','black','FontSize',12);
text(-3,0,'|','Color','black','FontSize',12);
text(0,3,'-','Color','black','FontSize',12);
text(0,-3,'-','Color','black','FontSize',12);
text(3,-0.5,'3','Color','red','FontSize',14);
text(-3,-0.5,'-3','Color','red','FontSize',14);
text(-0.5,3,'3j','Color','red','FontSize',14);
text(-0.5,-3,'-3j','Color','red','FontSize',14);

% Constellation Display: SNR = 15

scatterplot(Noisy_Mod15,4);title('Constellation - SNR = 15 ')
yline(0,'LineWidth',2);xline(0,'LineWidth',2);

text(3,0,'|','Color','black','FontSize',12);
text(-3,0,'|','Color','black','FontSize',12);
text(0,3,'-','Color','black','FontSize',12);
text(0,-3,'-','Color','black','FontSize',12);
text(3,-0.5,'3','Color','red','FontSize',14);
text(-3,-0.5,'-3','Color','red','FontSize',14);
text(-0.5,3,'3j','Color','red','FontSize',14);
text(-0.5,-3,'-3j','Color','red','FontSize',14);

% Constellation Display: SNR = 25

scatterplot(Noisy_Mod25,4);title('Constellation - SNR = 25 ')
yline(0,'LineWidth',2);xline(0,'LineWidth',2);

text(3,0,'|','Color','black','FontSize',12);
text(-3,0,'|','Color','black','FontSize',12);
text(0,3,'-','Color','black','FontSize',12);
text(0,-3,'-','Color','black','FontSize',12);
text(3,-0.5,'3','Color','red','FontSize',14);
text(-3,-0.5,'-3','Color','red','FontSize',14);
text(-0.5,3,'3j','Color','red','FontSize',14);
text(-0.5,-3,'-3j','Color','red','FontSize',14);

%% (4) Calculation of Signal Energy

% E(s1)=E(s2)=E(s3)=E(s4)
Re=real(S1); 
Im=imag(S1);

Es1=sqrt(Re.^2+Im.^2).^2; % Energy of a single symbol

%Total Energy: One symbol energy * Num. of Symbols

Es_tot = Es1 * length(QPSK_Mod);

%% (5) Demodulation for Noisy Signal -> SNR = 5;

QPSK_Demod5=[];

for j=1:len/2
    
    if real(Noisy_Mod5(j)) > 0 && imag(Noisy_Mod5(j)) > 0
       P=[0,0];
    
    elseif real(Noisy_Mod5(j)) > 0 && imag(Noisy_Mod5(j)) < 0
        P=[0,1];
        
    elseif real(Noisy_Mod5(j)) < 0 && imag(Noisy_Mod5(j)) < 0
        P=[1,0];
    
    elseif real(Noisy_Mod5(j)) < 0 && imag(Noisy_Mod5(j)) > 0
        P=[1,1];
        
    end
    QPSK_Demod5 = [QPSK_Demod5, P];
    
end

QPSK_Demod5=uint8(QPSK_Demod5.');

mat5=(reshape(QPSK_Demod5,[8,(length(QPSK_Demod5)/8)])).';
dec5=bi2de(mat5,'left-msb');

reconst_5=reshape(dec5,[31 31 3]);       
   
%% (5) Demodulation for Noisy Signal --> SNR = 8;

QPSK_Demod8=[];

for j=1:len/2
    
    if real(Noisy_Mod8(j)) > 0 && imag(Noisy_Mod8(j)) > 0
       P=[0,0];
    
    elseif real(Noisy_Mod8(j)) > 0 && imag(Noisy_Mod8(j)) < 0
        P=[0,1];
        
    elseif real(Noisy_Mod8(j)) < 0 && imag(Noisy_Mod8(j)) < 0
        P=[1,0];
    
    elseif real(Noisy_Mod8(j)) < 0 && imag(Noisy_Mod8(j)) > 0
        P=[1,1];
        
    end
    QPSK_Demod8 = [QPSK_Demod8, P];
    
end

QPSK_Demod8=uint8(QPSK_Demod8.');

mat8=(reshape(QPSK_Demod8,[8,(length(QPSK_Demod8)/8)])).';
dec8=bi2de(mat8,'left-msb');

reconst_8=reshape(dec8,[31 31 3]);

%% (5) Demodulation for Noisy Signal --> SNR = 15;

QPSK_Demod15=[];

for j=1:len/2
    
    if real(Noisy_Mod15(j)) > 0 && imag(Noisy_Mod15(j)) > 0
       P=[0,0];
    
    elseif real(Noisy_Mod15(j)) > 0 && imag(Noisy_Mod15(j)) < 0
        P=[0,1];
        
    elseif real(Noisy_Mod15(j)) < 0 && imag(Noisy_Mod15(j)) < 0
        P=[1,0];
    
    elseif real(Noisy_Mod15(j)) < 0 && imag(Noisy_Mod15(j)) > 0
        P=[1,1];
        
    end
    QPSK_Demod15 = [QPSK_Demod15, P];
    
end

QPSK_Demod15=uint8(QPSK_Demod15.');

mat15=(reshape(QPSK_Demod15,[8,(length(QPSK_Demod15)/8)])).';
dec15=bi2de(mat15,'left-msb');

reconst_15=reshape(dec15,[31 31 3]);

%% (5) Demodulation for Noisy Signal with SNR = 25;

QPSK_Demod25=[];

for j=1:len/2
    
    if real(Noisy_Mod25(j)) > 0 && imag(Noisy_Mod25(j)) > 0
       P=[0,0];
    
    elseif real(Noisy_Mod25(j)) > 0 && imag(Noisy_Mod25(j)) < 0
        P=[0,1];
        
    elseif real(Noisy_Mod25(j)) < 0 && imag(Noisy_Mod25(j)) < 0
        P=[1,0];
    
    elseif real(Noisy_Mod25(j)) < 0 && imag(Noisy_Mod25(j)) > 0
        P=[1,1];
        
    end
    QPSK_Demod25 = [QPSK_Demod25, P];
    
end

QPSK_Demod25=uint8(QPSK_Demod25.');

mat25=(reshape(QPSK_Demod25,[8,(length(QPSK_Demod25)/8)])).';
dec25=bi2de(mat25,'left-msb');

reconst_25=reshape(dec25,[31 31 3]);

%% (6) Plot Reconstructed Image for SNR = [5, 8, 15, 25]

figure('name','Reconstructed Image');

subplot(221)
imshow(reconst_5);title('SNR = 5');
subplot(222)
imshow(reconst_8);title('SNR = 8');
subplot(223)
imshow(reconst_15);title('SNR = 15');
subplot(224)
imshow(reconst_25);title('SNR = 25');

%% (7) Bit BER Calculation --> SNR = 5,8,15,25

% SNR = 5:
BitCount5=0;
for k=1:len
    if QPSK_Demod5(k) ~= bitStream(k)
        BitCount5= BitCount5 +1;
    end
end
        
BER5=  BitCount5/len;                  %Total BER for SNR = 5

%SNR = 8:
BitCount8= 0;

for k=1:len
    if QPSK_Demod8(k) ~= bitStream(k)
        BitCount8= BitCount8 +1;
    end
end

BER8 = BitCount8/len;

%SNR = 15:

BitCount15=0;
for k=1:len
    if QPSK_Demod15(k) ~= bitStream(k)
        BitCount15= BitCount15 +1;
    end
end
BER15 = BitCount15/len;

%SNR=25:
BitCount25=0;

for k=1:len
    if QPSK_Demod25(k) ~= bitStream(k)
        BitCount25= BitCount25 +1;
    end
end

BER25 = BitCount25/len;

% Total Number of Bit Errors (All SNRs) = [5,8,15,25];

BitErr = [BitCount5, BitCount8, BitCount15, BitCount25];

% Overall BER + BER in Percentage (All SNRs) =  [5,8,15,25]:

BER = [BER5, BER8, BER15, BER25];
BER_percent = 100* BER; 
%% (8) Symbol BER Calculation --> SNR = 5,8,15,25

% SNR =5:

SymVec5=0;

for i=1:2:len
    if QPSK_Demod5(i)~= bitStream(i) || QPSK_Demod5(i+1) ~= bitStream(i+1)
        SymVec5=SymVec5 + 1;
    end    
end

%SNR = 8

SymVec8=0;

for i=1:2:len
    if QPSK_Demod8(i)~= bitStream(i) || QPSK_Demod8(i+1) ~= bitStream(i+1)
        SymVec8=SymVec8 + 1;
    end    
end

%SNR = 15

SymVec15=0;

for i=1:2:len
    if QPSK_Demod15(i)~= bitStream(i) || QPSK_Demod15(i+1) ~= bitStream(i+1)
        SymVec15=SymVec15 + 1;
    end    
end

%SNR = 25

SymVec25=0;
for i=1:2:len
    if QPSK_Demod25(i)~= bitStream(i) || QPSK_Demod25(i+1) ~= bitStream(i+1)
        SymVec25=SymVec25 + 1;
    end    
end

% Total Symbol Ber for All SNRs = [5,8,15,25] : 


SER = ( [SymVec5, SymVec8, SymVec15, SymVec25] ) / (len/2);