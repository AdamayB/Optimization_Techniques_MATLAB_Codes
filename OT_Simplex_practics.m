clc
clear all


C=[3 2 5];
Noofvariables=size(C,2);
Info=[1 2 1;1 4 0;3 0 2];
b=[430;460;420];
s=eye(size(Info,1));
A=[Info s b];

Cost=zeros(1,size(A,2));
Cost(1:Noofvariables)=C;

BV=Noofvariables+1:size(A,2)-1;
ZjCj=Cost(BV)*A-Cost;
zcj=[ZjCj;A];
RUN=true
while RUN

if any(ZjCj<0)
    ZC=ZjCj(1:end-1);
    [EnterCol,pvt_col]=min(ZC);
    sol=A(:,end);
    Column=A(:,pvt_col);
    if all(Column<=0)
        error('Unbounded!!')
    else
    for i=1:size(Column,1)
        if Column(i)>0
            ratio(i)=sol(i)./Column(i);
        else
            ratio(i)=Inf;
        end
    end
    [MinRatio,pvt_row]=min(ratio);
    end
    BV(pvt_row)=pvt_col;
    fprintf('++==================================================================++\n')
    disp(BV);
    pvt_key=A(pvt_row,pvt_col);
    A(pvt_row,:)=A(pvt_row,:)./pvt_key;
    for i=1:size(A,1)
        if i~=pvt_row
            A(i,:)=A(i,:)-A(i,pvt_col).*A(pvt_row,:);
        end
    end
        ZjCj=ZjCj-ZjCj(pvt_col).*A(pvt_row,:);
        zcj=[ZjCj;A];
        TABLE=array2table(zcj);
        TABLE.Properties.VariableNames(1:size(zcj,2))={'x1','x2','x3','s1','s2','s3','Sol'}
        BFS=zeros(1,size(A,2));
        BFS(BV)=A(:,end);
        BFS(end)=sum(BFS.*Cost);
        Current_BFS=array2table(BFS);
        Current_BFS.Properties.VariableNames(1:size(Current_BFS,2))={'x1','x2','x3','s1','s2','s3','Sol'}
    
else
    RUN=false;
        disp('Optimal Solution Has been reached.')
end
end