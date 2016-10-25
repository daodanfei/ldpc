function [u]= extract_mesg(c,rearranged_cols)
%u= extract_mesg(c,rearranged_cols)
%For examples and more details, please refer to the LDPC toolkit tutorial at
%http://arun-10.tripod.com/ldpc/ldpc.htm 
rows=length(rearranged_cols);
for i=1:rows
   if rearranged_cols(i)~=0
      temp=c(i);
      c(i)=c(rearranged_cols(i));
      c(rearranged_cols(i))=temp;
   end
end
cols=length(c);
u=c(rows+1:cols);
