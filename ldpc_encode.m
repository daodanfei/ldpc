function [u,P,rearranged_cols]=ldpc_encode(s,H)
%             高斯消元
%设H=[A | B] ==========> [I | P]
%  u=[c | s]
%∵  H*u' = u*H' = 0
%代入得：
%         _    _
%         | c' |
%  [I | P]|    | = 0
%         | s' |
%         -    -
%∴I*c' + P*s' = 0
%∴I*c' = P*s' (在GF(2)上)
%∴  c' = P*s' 
%再由u=[c | s]即可得到编码后的码字。
%如果高斯消元过程中进行了列交换，
%则只需记录列交换，并以相反次序对编码后的码字同样进行列交换即可。
%解码时先求出u，再进行列交换得到uu=[c | s]，后面部分即是想要的信息。

dim=size(H);
rows=dim(1);
cols=dim(2);

[P,rearranged_cols]=H2P(H);%得到P矩阵以及系统编码后进行的列变换

c=mul_GF2(P,s');

u=[c' s]; 

% u1=[c' s]; 

% u=reorder_bits(u1,rearranged_cols);%重排序
