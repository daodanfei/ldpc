function [H]=genH(rows,cols)

row_flag(1:rows)=0;
parity_check=zeros(rows,cols);

%add bits_per_col 1's to each column with the only constraint being that the 1's should be
%placed in distinct rows
%%%%%%%%使每列随机产生3个1即列重为3%%%%%%%%%%%%%
bits_per_col=3;
for i=1:cols
   a=randperm(rows);
   for j=1:bits_per_col
      parity_check(a(j),i)=1;
      row_flag(a(j))=row_flag(a(j))+1;
   end
end

%计算每行1的最多个数
max_ones_per_row=ceil(cols*bits_per_col/rows);

%add 1's to rows having no 1(a redundant row) or only one 1(that bit in the codeword becomes
%zero irrespective of the input)
for i=1:rows
   if row_flag(i)==0    %如果该行没有1，则随机添加两个1
     for k=1:2
        j=unidrnd(cols);
        while parity_check(i,j)==1
            j=unidrnd(cols);
        end
        parity_check(i,j)=1;        %在找到的新位置上置1
        row_flag(i)=row_flag(i)+1;  %行重加1
      end
   end
   if row_flag(i)==1    %如果该行只有1个1，则随机再添加1个1
      j=unidrnd(cols);
      while parity_check(i,j)==1
         j=unidrnd(cols);
      end
      parity_check(i,j)=1;
      row_flag(i)=row_flag(i)+1;
   end
end

%try to distribute the ones so that the number of ones per row is as uniform as possible
%尝试在列上分散1的位置，使得每行1的个数均衡（相近或相一致）
for i=1:rows
   j=1;
   a=randperm(cols);
   while row_flag(i)>max_ones_per_row;  %如果该行行重大于允许的最大行重，则进行处理
      if parity_check(i,a(j))==1 %随机选择某一该行上为1的列来处理，将该列该行上的1分散到其他的行
         %随机查找该列上适合放置1（行重小于允许的最大行重，且该位置上为0）的行
         newrow=unidrnd(rows);
         k=0;
         while (row_flag(newrow)>=max_ones_per_row | parity_check(newrow,a(j))==1) & k<rows
            newrow=unidrnd(rows);
            k=k+1;
         end
         if parity_check(newrow,a(j))==0
            %将待处理行上的1转放到找到的行上
            parity_check(newrow,a(j))=1;
            row_flag(newrow)=row_flag(newrow)+1;
            parity_check(i,a(j))=0;
            row_flag(i)=row_flag(i)-1;
         end
      end%if test
      j=j+1;
   end%while loop
end%for loop

%try to eliminate cycles of length 4 in the factor graph
%尝试删除4环
for loop=1:10
   chkfinish=1;
   for r=1:rows
      ones_position=find(parity_check(r,:)==1);
      ones_count=length(ones_position);
      for i=[1:r-1 r+1:rows]
         common=0;
         for j=1:ones_count
            if parity_check(i,ones_position(j))==1
               common=common+1 ;
               if common==1
                  thecol=ones_position(j);
               end
            end
            if common==2
               chkfinish=0; %如果还存在4环，则不结束循环，还进入下一次循环
               common=common-1;
               if (round(rand)==0)           % 随机决定是保留前面的列还是后面的列
                  coltoberearranged=thecol;           %保留后面的列，交换前面的列
                  thecol=ones_position(j);
               else
                  coltoberearranged=ones_position(j); %保留前面的列，交换后面的列
               end
               parity_check(i,coltoberearranged)=3; %make this entry 3 so that we dont use
                                                    %of this entry again while getting rid
                                                    %of other cylces
               newrow=unidrnd(rows);
               iteration=0;     %尝试5次在待交换的列中随机查找0
               while parity_check(newrow,coltoberearranged)~=0 & iteration<5
                  newrow=unidrnd(rows);
                  iteration=iteration+1;
               end
               if iteration>=5  %超过5次后则扩大范围随机查找非1的0或3，直到找到为止
                  while parity_check(newrow,coltoberearranged)==1
                     newrow=unidrnd(rows);
                  end
               end
               %把该列中找到的0或3置为1
               parity_check(newrow,coltoberearranged)=1;
            end%if common==2
         end%for j=1:ones_count
      end%for i=[1:r-1 r+1:rows]
   end%for r=1:rows

   %如果本次循环已不存在4环，则结束循环，不进入下一次循环
   if chkfinish
      break
   end
end%for loop=1:10

%replace the 3's with 0's
parity_check=parity_check==1;

%Get the Parity Checks
H=parity_check;

%%%%%下面的求方差仅用作评估%%%%
%%计算列重
%col_flag(1:cols)=0;
%for j=1:cols
%   ind=find(H(:,j)==1);
%   col_flag(j)=length(ind);
%end
%%计算行重
%row_flag(1:rows)=0;
%for i=1:rows
%   ind=find(H(i,:)==1);
%   row_flag(i)=length(ind);
%end
%%每行1的个数的方差
%variance=var(row_flag);
