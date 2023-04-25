clc
clear all

Cost=[2 7 4;
      3 3 1;
      5 5 4;
      1 6 2];
A=[5 8 7 14];
B=[7 9 18];
if sum(A)==sum(B)
    fprintf("Balanced Problem.\n")
else
    fprintf('Unbalanced.\n')
    if sum(A)<sum(B)
        Cost(end+1,:)=zeros(1,size(A,2));
        A(end+1)=sum(B)-sum(A);
    elseif sum(A)>sum(B)
        Cost(:,end+1)=zeros(1,size(A,1));
        B(end+1)=sum(A)-sum(B);
    end
end
ICost=Cost;
X=zeros(size(Cost));
[m,n]=size(Cost);
BFS=m+n-1;
%% Minimum Cost
for i=1:size(Cost,1)
    for j=1:size(Cost,2)
        hh=min(Cost(:));
        [rowind,colind]=find(hh==Cost)
        A(rowind)
        x11=min(A(rowind),B(colind))
        [val,ind]=max(x11)
        ii=rowind(ind);
        jj=colind(ind);
        y11=min(A(ii),B(jj));
        X(ii,jj)=y11;
        A(ii)=A(ii)-y11;
        B(jj)=B(jj)-y11;
        Cost(ii,jj)=Inf;
    end
end
fprintf("Initial BFS:\n");
IB=array2table(X);
disp(IB)
TotalBFS=length(nonzeros(X));
if TotalBFS==BFS
    fprintf("Not Degenerate\n")
else
    fprintf("Degenerate\n")
end
InitialCost=sum(sum(ICost.*X));
fprintf('Initial BFS Cost=%d\n',InitialCost);