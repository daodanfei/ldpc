function [waveform]=bpsk(bitseq,amplitude)
%waveform=bpsk(bitseq,amplitude)
%For examples and more details, please refer to the LDPC toolkit tutorial at
%http://arun-10.tripod.com/ldpc/ldpc.htm
for i=1:length(bitseq)
   if bitseq(i)==1
      waveform(i)=amplitude;
   else
      waveform(i)=-amplitude;
   end
end
