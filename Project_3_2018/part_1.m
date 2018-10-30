close all
format compact
hold on

load("P2_data.mat");

plot(X(Y>0, 1), X(Y>0, 2), 'ro');
plot(X(Y<0, 1), X(Y<0, 2), 'go');

title('Training data and boundaries')
xlabel('x1') 
ylabel('x2')

%Training
n = size(X,1);
H = (Y*Y').*(X*X');
H = H + eye(n)*1e-7;
p = repmat(-1,n,1);
Aeq = Y';
beq = 0;
A = -1 * eye(n);
b = repmat(0,n,1);

alpha = quadprog(H,p,A,b,Aeq,beq);

support_vectors = find(alpha>0.01) %0.4362, 0.8538, 0.4177
w2summation = alpha.*Y.*X;
w = sum(w2summation)';

bias = mean(Y(support_vectors)-Xw(support_vectors));

%Results
w
bias
margin = 1/norm(w)
support_vector_alphas = alpha(support_vectors)
test_3_4 = w' * [3 4]' + bias
test_6_6 = w' * [6 6]' + bias
size(w')

%Plotting
xs = xlim;
bound_ys = (-bias - w(1)*xs)/w(2);
marg1_ys = (1 - bias - w(1)*xs)/w(2);
marg2_ys = (-1 - bias - w(1)*xs)/w(2);
plot(xs,bound_ys,'b');
plot(xs,marg1_ys,'b--');
plot(xs,marg2_ys,'b--');

Xsv = X(support_vectors,:);
plot(Xsv(:,1),Xsv(:,2),'bo','markersize',10);






