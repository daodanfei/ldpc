H=zeros(3000,4000);

for i=1:3000
    for j=1:5
        if(code1_compressedH(i,j)~=0)
            H(i,code1_compressedH(i,j))=1;
        end
    end
end