close all
format compact
hold on
rng(1, 'v4normal')

load("P2_data.mat")


%plot(X(Y>0, 1), X(Y>0, 2), 'ro')
%plot(X(Y<0, 1), X(Y<0, 2), 'bo')

title('Training data and boundaries')
xlabel('x1') 
ylabel('x2')
%legend({'Positive','Negative','Part 1a/1b', 'Part 1d', 'Outlier', 'Part 2a', 'Part 2b','Part 2c','Part 3'})


ma = {'ko','ks'};
fc = {[0 0 0],[1 1 1]};
tv = unique(Y);
figure(1); hold off
for i = 1:length(tv)
    pos = find(Y==tv(i));
    plot(X(pos,1),X(pos,2),ma{i},'markerfacecolor',fc{i});
    hold on
end



N = size(X,1);
K = X*X';
H = (Y*Y').*K + 1e-5*eye(N);
f = repmat(1,N,1);
A = [];b = [];
LB = repmat(0,N,1); UB = repmat(inf,N,1);
Aeq = Y';beq = 0;

% Following line runs the SVM
alpha = quadprog(H,-f,A,b,Aeq,beq,LB,UB);
% Compute the bias
fout = sum(repmat(alpha.*Y,1,N).*K,1)';
pos = find(alpha>1e-6);
b = mean(Y(pos)-fout(pos));
b



figure(1);hold off
pos = find(alpha>1e-6);
plot(X(pos,1),X(pos,2),'ko','markersize',15,'markerfacecolor',[0.6 0.6 0.6],...
    'markeredgecolor',[0.6 0.6 0.6]);
hold on
for i = 1:2 %length(tv)
    pos = find(Y==tv(i));
    plot(X(pos,1),X(pos,2),ma{i},'markerfacecolor',fc{i});
end

xp = xlim;
% Because this is a linear SVM, we can compute w and plot the decision
% boundary exactly.
w = sum(repmat(alpha.*Y,1,2).*X,1)';
yp = -(b + w(1)*xp)/w(2);
plot(xp,yp,'k','linewidth',2)


