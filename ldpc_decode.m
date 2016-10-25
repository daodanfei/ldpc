function [uhat,vhat]=ldpc_decode(rx_waveform,SNR,amp,scale,H,rearranged_cols)

dim=size(H);
rows=dim(1);
cols=dim(2);

vhat(1,1:cols)=0;

zero(1,1:rows)=0;

s=struct('qmn0',0,'qmn1',0,'dqmn',0,'rmn0',0,'rmn1',0,'qn0',0,'qn1',0,'alphamn',1);
%associate this structure with all non zero elements of H

%Prior Probabilities
%先验概率
pl1=1./(1+exp(-2*amp*rx_waveform.*scale/(SNR/2)));
pl0=1-pl1;

%initialization
%初始化：对特定的信道预设信息比特的先验概率。
newh(1:rows, 1:cols)=s;
[h1i h1j]=find(H==1);
h1num=length(h1i);
for i=1:h1num
    newh(h1i(i),h1j(i)).qmn0=pl0(h1j(i));
    newh(h1i(i),h1j(i)).qmn1=pl1(h1j(i));
end

%迭代次数100
for iteration=1:100
    %horizontal step
    %横向步骤：由信息节点的先验概率按置信传播算法得出各校验节点的后验概率。
    for i=1:h1num %计算概率差
        newh(h1i(i),h1j(i)).dqmn=newh(h1i(i),h1j(i)).qmn0-newh(h1i(i),h1j(i)).qmn1;
    end

    for i=1:rows
        colind=find(h1i==i);
        colnum=length(colind);
        for j=1:colnum
            drmn=1;
            for k=1:colnum
                if k~=j
                    drmn=drmn*newh(i,h1j(colind(k))).dqmn;
                end
            end
            newh(i,h1j(colind(j))).rmn0=(1+drmn)/2;
            newh(i,h1j(colind(j))).rmn1=(1-drmn)/2;
        end
    end

    %vertical step
    %纵向步骤：由校验节点的后验概率推算出信息节点的后验概率。
    for j=1:cols
        rowind=find(h1j==j);
        rownum=length(rowind);
        for i=1:rownum
            prod_rmn0=1;
            prod_rmn1=1;
            for k=1:rownum
                if k~=j
                    prod_rmn0=prod_rmn0*newh(h1i(rowind(k)),j).rmn0;
                    prod_rmn1=prod_rmn1*newh(h1i(rowind(k)),j).rmn1;
                end
            end
            const1=pl0(j)*prod_rmn0;
            const2=pl1(j)*prod_rmn1;
            newh(h1i(rowind(i)),j).alphamn=1/( const1 + const2 ) ;
            newh(h1i(rowind(i)),j).qmn0=newh(h1i(rowind(i)),j).alphamn*const1;
            newh(h1i(rowind(i)),j).qmn1=newh(h1i(rowind(i)),j).alphamn*const2;
            %update pseudo posterior probability
            %更新伪后验概率
            const3=const1*newh(h1i(rowind(i)),j).rmn0;
            const4=const2*newh(h1i(rowind(i)),j).rmn1;
            alpha_n=1/(const3+const4);
            newh(h1i(rowind(i)),j).qn0=alpha_n*const3;
            newh(h1i(rowind(i)),j).qn1=alpha_n*const4;
            %tentative decoding
            %译码尝试，对信息节点的后验概率作硬判决
            if newh(h1i(rowind(i)),j).qn1>0.5
                vhat(j)=1;
            else
                vhat(j)=0;
            end
        end
    end


    if mul_GF2(vhat,H.')==zero
    %如果判决条件满足，译码结束，否则继续迭代
        break;
    end
end

uhat = extract_mesg(vhat,rearranged_cols);
