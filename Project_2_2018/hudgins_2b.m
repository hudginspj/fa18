close all
format compact
hold on

%readtable("glass")

%load("glass", 'ascii')

[Y X]=libsvmread('glass');  
X=full(X);
hold off

X=normalize(X);
shuffle_idx = randperm(length(Y));
X = X(shuffle_idx,:);
Y = Y(shuffle_idx);


plot(X(Y==1, 1), X(Y==1, 2), 'ro');
plot(X(Y~=1, 1), X(Y~=1, 2), 'go');

title('Training data and boundaries')
xlabel('x1') 
ylabel('x2')



Y ;
Y1 = (Y==1)*2 -1;

%for i = 1:length(C0)
%    C = C0(i);
%    for j = 1:length(parameters)
%        param = parameters(j)
%        …
%    end
%end

train_soft(X, Y1, 1);

function [w, b] = train_soft(X, Y, C)

    n = size(X,1);
    H = (Y*Y').*(X*X');
    H = H + eye(n)*1e-7;
    p = repmat(-1,n,1);
    Aeq = Y';
    beq = 0;
    A1 = -1 * eye(n);  % Flip the normal constraint
    b1 = repmat(0,n,1);
    LB = repmat(0,n,1);
    UB = repmat(C,n,1);
    
    alpha = quadprog(H,p,A1,b1,Aeq,beq);


    support_vectors = find(alpha>0.01);
    w2summation = alpha.*Y.*X;
    w = sum(w2summation)';


    Xw = X*w;
    b = mean(Y(support_vectors)-Xw(support_vectors));
    
    w;
    b;
    margin = 1/norm(w);
    sv_alphas = alpha(support_vectors);

    xs = xlim;
    bound_ys = (-b - w(1)*xs)/w(2);
    marg1_ys = (1 - b - w(1)*xs)/w(2);
    marg2_ys = (-1 - b - w(1)*xs)/w(2);
    plot(xs,bound_ys,'b');
    plot(xs,marg1_ys,'b--');
    plot(xs,marg2_ys,'b--');

    Xsv = X(support_vectors,:);
    plot(Xsv(:,1),Xsv(:,2),'bo','markersize',10);
end


function [d] = decision_hard(w, b, x)
    d = w' * x' + b
end