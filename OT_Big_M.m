clc
clear all;

% Variables={'x1','x2','s2','s3','A1','A2','Sol'};
M=1000;
% Cost=[-2 -1 0 0 -M -M 0];
% A=[3 1 0 0 1 0 3;
%   4 3 -1 0 0 1 6;
%    1 2 0 1 0 0 3];
% s=eye(size(A,1));

% Cost=[-4 -5 0 0 -1000 -1000 0]
% A=[3 1 1 0 0 0 27; 3 2 0 -1 1 0 3; 5 5 0 0 0 1 60]
% s=eye(size(A,1));

Cost=[-3 -5 0 0 -M -M 0];
Variables={'x1','x2','s1','s2','A1','A2','Sol'};
A=[1 3 -1 0  1 0 3;
   1 1  0 -1 0 1 2];
s=eye(size(A,1));

% Cost=[12 10 0 0 0 -1000 -1000 -1000 0]
% A=[5 1 -1 0 0 1 0 0 10; 
%    6 5 0 -1 0 0 1 0 30; 
%    1 4 0 0 -1 0 0 1 8];
%s=eye(size(A,1));
% 
% Cost=[0 0 0 0 -M -M 0];
% A=[3 2 -3 0 1 0 2;
%   4 -3 3 0 0 1 4;
%    2 -3 4 1 0 0 7];
% s=eye(size(A,1));


BV=[];
for j=1:size(s,2)
    for i=1:size(A,2)
        if A(:,i)==s(:,j)
            BV=[BV i];
        end
    end
end
ZjCj=Cost(BV)*A-Cost;
ZCj=[ZjCj;A];
SimpTable=array2table(ZCj);
%SimpTable.Properties.VariableNames(1:size(ZCj,2))=Variables
RUN=true;
while RUN
ZC=ZjCj(:,1:end-1);
if any(ZC<0)
    fprintf("Not Optimal\n")
    [Enterval,pvt_col]=min(ZC);

    sol=A(:,end);
    Column=A(:,pvt_col);
    if all(Column)<=0
        fprintf('Solution is Unbounded\n')
    else
        for i=1:size(Column,1)
            if Column(i)>0
                ratio(i)=sol(i)./Column(i);
            else
                ratio(i)=inf;
            end
        end
        [MinR,pvt_row]=min(ratio);
        BV(pvt_row)=pvt_col;
        pvt_key=A(pvt_row,pvt_col);
        A(pvt_row,:)=A(pvt_row,:)./pvt_key;
        for i=1:size(A,1)
            if i~=pvt_row
                A(i,:)=A(i,:)-A(i,pvt_col).*A(pvt_row,:);
            end
        end
        ZjCj=Cost(BV)*A-Cost;
        ZCj=[ZjCj; A];
        Table=array2table(ZCj);
        %Table.Properties.VariableNames(1:size(ZCj,2))=Variables
    end

else
    RUN=false;
    fprintf('Optimum Reached\n')
end
end
Final_BFS=zeros(1,size(A,2));
Final_BFS(BV)=A(:,end);
Final_BFS(end)=sum(Final_BFS.*Cost);

OptimalBFS=array2table(Final_BFS);
OptimalBFS.Properties.VariableNames(1:size(OptimalBFS,2))=Variables