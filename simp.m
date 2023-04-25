function[BFS, A]=simp(A,BV,Cost,Variables)
ZjCj=Cost(BV)*A-Cost;
RUN=true;
while RUN
ZC=ZjCj(1,1:end-1);
if any(ZC<0)
    [EnterCol, pvt_col]=min(ZC);
    sol=A(:,end);
    Column=A(:,pvt_col);
    if Column<0
        fprintf('Unbounded Solution.')
    else
        for i=1:size(A,1)
            if Column(i)>0
                ratio(i)=sol(i)./Column(i);
            else
                ratio(i)=inf;
            end
        end
        [MinRatio, pvt_row]=min(ratio);
    end
    BV(pvt_row)=pvt_col;
    % Pivot Key
    pvt_key=A(pvt_row,pvt_col);
    A(pvt_row,:)=A(pvt_row,:)./pvt_key;
    for i=1:size(A,1)
        if i~=pvt_row
            A(i,:)=A(i,:)-A(i,pvt_col).*A(pvt_row,:);
        end
    end
    ZjCj=ZjCj-ZjCj(pvt_col).*A(pvt_row,:);
    ZCj=[ZjCj;A];
    Table=array2table(ZCj);
    Table.Properties.VariableNames(1:size(A,2))=Variables
    BFS(BV)=A(:,end);
else
    fprintf('Optimal Solution Has Been Reached.')
    RUN=false
    BFS=BV;
end
end