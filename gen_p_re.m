load d3code1.txt
H=zeros(3000,4000);

for i=1:3000
    for j=1:5
        if(d3code1(i,j)~=0)
            H(i,d3code1(i,j))=1;
        end
    end
end

[P,rearranged_cols]=H2P(H);

fp=fopen('P1.txt','w');
fre=fopen('rearranged_cols1.txt','w');
% fp=fopen('P1.txt','w');
for i=1:

