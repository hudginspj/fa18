close all
format compact
hold on
rng(1, 'v4normal')

load("P2_data.mat")


plot(X(Y>0, 1), X(Y>0, 2), 'ro')
plot(X(Y<0, 1), X(Y<0, 2), 'go')

title('Training data and boundaries')
xlabel('x1') 
ylabel('x2')
%legend({'Positive','Negative','Part 1a/1b', 'Part 1d', 'Outlier', 'Part 2a', 'Part 2b','Part 2c','Part 3'})


%ma = {'ko','ks'};
%fc = {[0 0 0],[1 1 1]};
%tv = unique(Y);
%figure(1); hold off
%for i = 1:length(tv)
%    pos = find(Y==tv(i));
%    plot(X(pos,1),X(pos,2),ma{i},'markerfacecolor',fc{i});
%    hold on
%end



n = size(X,1);
H = (Y*Y').*(X*X');
H = H + eye(n)*1e-7
p = repmat(-1,n,1);
Aeq = Y';
beq = 0;
A1 = -1 * eye(n)
b1 = repmat(0,n,1)
% Following line runs the SVM
alpha = quadprog(H,p,A1,b1,Aeq,beq);
%alpha = quadprog(H,-f,A,b,Aeq,beq,LB,UB);
% Compute the bias
%fout = sum(repmat(alpha.*Y,1,n).*(X*X'),1)';
%pos = find(alpha>1e-6);
%b = mean(Y(pos)-fout(pos));




%figure(1);hold off
%pos = find(alpha>1e-6);
%plot(X(pos,1),X(pos,2),'ko','markersize',15,'markerfacecolor',[0.6 0.6 0.6],...
%    'markeredgecolor',[0.6 0.6 0.6]);
%hold on
%for i = 1:2 %length(tv)
%    pos = find(Y==tv(i));
%    plot(X(pos,1),X(pos,2),ma{i},'markerfacecolor',fc{i});
%end

%xp = xlim;
% Because this is a linear SVM, we can compute w and plot the decision
% boundary exactly.
support_vectors = find(alpha>0.01) %0.4362, 0.8538, 0.4177
w2summation = alpha.*Y.*X;
w = sum(w2summation)';
%w2b = repmat(alpha.*Y,1,2).*X
%w2 = sum(w2b, 1)

%w = sum(repmat(alpha.*Y,1,2).*X,1)'

Xw = X*w;
b = mean(Y(support_vectors)-Xw(support_vectors));

w
b
margin = 1/norm(w)
sv_alphas = alpha(support_vectors)
test1 = w' * [3 4]' + b
test2 = w' * [6 6]' + b

%w1 x  + w2 y + b = 0



xs = xlim;
bound_ys = (-b - w(1)*xs)/w(2);
marg1_ys = (1 - b - w(1)*xs)/w(2);
marg2_ys = (-1 - b - w(1)*xs)/w(2);
plot(xs,bound_ys,'b');
plot(xs,marg1_ys,'b--');
plot(xs,marg2_ys,'b--');

Xsv = X(support_vectors,:)
plot(Xsv(:,1),Xsv(:,2),'bo','markersize',10);






