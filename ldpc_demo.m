clear all;
clc;

%rate = (cols-rows)/cols;
rows=500;
cols=1000;

%产生H矩阵
H=genH(rows,cols);

nerr = 0;    %统计错误比特数
fnum = 50;   %单点重复循环次数
for i=1:fnum
    s=round(rand(1, cols-rows));

    %使用H矩阵进行LDPC编码
    [u,P,rearranged_cols]=ldpc_encode(s,H);

    SNR=3;
    amp=1;
    tx_waveform=bpsk(u,amp);
    rx_waveform=awgn(tx_waveform,SNR);
    scale(1:length(u))=1;  %No fading.

    %LDPC译码
    rx_waveform=reorder_bits(rx_waveform,rearranged_cols);%重排序
    [uhat vhat]=ldpc_decode(rx_waveform,SNR,amp,scale,H,rearranged_cols);

    errmax=find(s~=uhat);
    fprintf('\n%d frames transmitted, ber = %8.4e .\n', i, length(errmax)/length(s));
    nerr = nerr + length(errmax);
    fprintf('errmax = %d, nerr = %d\n', length(errmax),nerr);
    fprintf('Average ber = %8.4e .\n', nerr/i/length(s));
end