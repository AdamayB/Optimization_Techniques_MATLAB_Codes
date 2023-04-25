% clc
% clear all

% Variables={'x1','x2','x3','s1','s2','A1','A2','Sol'};
% OVariables={'x1','x2','x3','s1','s2','Sol'};
% OrigC=[-7.5 3 0 0 0 -1 -1 0];
% Info=[3 -1 -1 -1 0 1 0 3; 1 -1 1 0 -1 0 1 2];
% BV=[6 7];
%Cost=[0 0 0 0 0 -1 -1 0];

Variables={'x1','x2','s2','s3','A1','A2','Sol'};
OVariables={'x1','x2','s2','s3','Sol'};
OrigC=[-2 -1 0 0 -1 -1 0];
Info=[3 1 0 0 1 0 3; 
     4 3 -1 0 0 1 6;
      1 2 0 1 0 0 3];
BV=[5 6 4];

%% Phase 1: -y1-y2
Cost=[0 0 0 0 -1 -1 0];
A= Info;
StartBV=find(Cost<0);


fprintf('====================Phase 1====================\n')
[BFS,A]=TwoPhase(A,BV,Cost,Variables);

%% Phase 2
fprintf('====================Phase 2====================\n')
A(:,StartBV)=[];
OrigC(:,StartBV)=[];
[OptBFS, OptA]=TwoPhase(A,BFS,OrigC,OVariables);

%% Phase 3
Final_BFS=zeros(1,size(A,2));
Final_BFS(OptBFS)=OptA(:,end);
Final_BFS(end)=sum(Final_BFS.*OrigC);

OptimalBFS=array2table(Final_BFS);
OptimalBFS.Properties.VariableNames(1:size(OptimalBFS,2))=OVariables
