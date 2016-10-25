function llr = Larg(LLR)
leng = size(LLR,2);
for i = 2:leng
    llr_2 = LLR(1,i);
    if(i == 2)
        llr_1 = LLR(1,1);
        llr_2 = LLR(1,2);
    end
    llr_new = log((1+exp(llr_1)*exp(llr_2))/(exp(llr_1)+exp(llr_2)))
    llr_1 = llr_new;
end
llr = llr_new;