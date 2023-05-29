clc
clear all

% Variables={'x1','x2','x3','s1','s2','Sol'};
% Cost=[-2 0 -1 0 0 0];
% Info=[-1 -1 1; -1 2 -4];
% b=[-5 ;-8];
% s=eye(size(Info,1));
% A=[Info s b];

Cost=[-3 -5 0 0 0];
Variables={'x1','x2','s1','s2','Sol'};
Info=[-1 -3;
   -1 -1];
b=[-3;-2]
s=eye(size(Info,1));
A=[Info s b];

BV=[];
for j=1:size(s,2)
    for i=1:size(A,2)
        if A(:,i)==s(:,j)
            BV=[BV i];
        end
    end
end

ZjCj=Cost(BV)*A-Cost
ZCj=[ZjCj;A];
SimpTable=array2table(ZCj);
SimpTable.Properties.VariableNames(1:size(ZCj,2))=Variables

%% Dual Simplex Start
RUN=true;
while RUN
    SOL=A(:,end);
    if any(SOL<0)
        fprintf("Not Feasible\n")
        [LeaVal,pvt_row]=min(SOL);
        ROW=A(pvt_row,1:end-1);
        ZJ=ZjCj(:,1:end-1);
        for i=1:size(ROW,2)
            if ROW(i)<0
                ratio(i)=abs(ZJ(i)./ROW(i));
            else
                ratio(i)=inf;
            end
        end
        ratio
        [minVal,pvt_col]=min(ratio);
        BV(pvt_row)=pvt_col;
        fprintf('Basic Variables=')
        disp(Variables(BV))
        pvt_key=A(pvt_row,pvt_col);
        A(pvt_row,:)=A(pvt_row,:)./pvt_key;
        for i=1:size(A,1)
            if i~=pvt_row
                A(i,:)=A(i,:)-A(i,pvt_col).*A(pvt_row,:);
            end
        end
        ZjCj=Cost(BV)*A-Cost;
        ZCj=[ZjCj;A];
        SimpTable=array2table(ZCj);
        SimpTable.Properties.VariableNames(1:size(ZCj,2))=Variables
    
    else
        RUN=false;
        fprintf("Feasible and Optimal!!\n")
    end
end
Final_BFS=zeros(1,size(A,2));
Final_BFS(BV)=A(:,end);
Final_BFS(end)=sum(Final_BFS.*Cost);

OptimalBFS=array2table(Final_BFS);
OptimalBFS.Properties.VariableNames(1:size(OptimalBFS,2))=Variables