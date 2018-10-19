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


% plot(X(Y==1, 1), X(Y==1, 2), 'ro');
% plot(X(Y~=1, 1), X(Y~=1, 2), 'go');
% 
% title('Training data and boundaries')
% xlabel('x1') 
% ylabel('x2')



Y ;
Y1 = (Y==1)*2 -1;

X_tra = X(1:10,:);

size(X_tra)
size(grbf_fast(X_tra, X, 1))

%size(polykernel(X_tra, X, 2))
size(linkernel(X_tra, X, 1))

[v, b] = train_soft(X, Y1, 1);

d = decision(v, b, linkernel(X, X(1,:), 1))
K_test = linkernel(X(1:200, :), X, 1)
[errors] = score(K_test, Y1(1:200), v, b)

%[errors] = xval(X, Y1, 1)
%[C, param] = optimize(X, Y1, [1e-2 1e-1 1 1e1 1e2 1e3 1e4], [1])

%num_classes = length(unique(Y))
%[ws, bs] = build_classifiers(X, Y)
%errors = final_evaluation(X, Y, ws, bs)

%G = grbf_fast(X, X, 1)

function [ws, bs] = build_classifiers(X, Y)
    yvals = unique(Y)'
    bs = []
    ws = []
    for i = yvals
        [ws(i,:), bs(i)] = build_classifer(X, Y, i);
    end
end



function errors = final_evaluation(X, Y, ws, bs)
    errors = 0;
    for i = 1:length(Y)
        [class] = prediction(X(i,:), ws, bs, unique(Y)');
        actual = Y(i);
        if class ~= actual
            errors = errors +1;
        end
    end
end

function [class] = prediction(x, ws, bs, yvals)
    d = [];
    
    for i = yvals
        x;
        w = ws(i,:);
        b = bs(i);
        d(i) = decision(w', b, x);
    end
    d;
    [val, class] = max(d);
end

function [Y1] = transform_y(Y, y_val)
    Y1 = (Y==y_val)*2 -1;
end

function [w, b] = build_classifer(X, Y, y_val)
    Y1 = transform_y(Y, y_val)
    [C, param] = optimize(X, Y1,[1e-2 1e-1 1 1e1 1e2 1e3 1e4], [1]);
    [w, b] = train_soft(X, Y1, C);
end

function [best_C, best_param] = optimize(X, Y, C0, parameters)
    best_C = 0;
    best_errors = inf;
    best_param = 0;
    for i = 1:length(C0)
        C = C0(i);
        for j = 1:length(parameters)
            param = parameters(j);
            [errors] = xval(X, Y, C); % ADD param
            %errors = 21
            if errors < best_errors
                best_errors = errors;
                best_C = C;
                best_param = param;
            end
        end
    end
end

function [errors] = xval(X, Y, C)
    indices = crossvalind('Kfold',length(Y),5);
    errors = 0;
    for i = 1:10
       test = (indices == i);
       tra = ~test;
       [w, b] = train_soft(X(tra,:), Y(tra), C);
       %pred = arrayfun(@(x) sign(x), X(test,:) * w');
       %y(test);
       %dif = pred - y(test);
       errors = errors + score(X(test,:), Y(test), w, b)
    end
end

function [errors] = score(K_test, Y, v, b)
    %K_test = kernel(X_test, X_train, param)
    dim = size(K_test)
    predictions = arrayfun(@(i) sign(decision(v, b, K_test(:,i)')), 1:dim(2));
    error_arr = ((predictions'.*Y)-1)/-2;
    errors = sum(error_arr);
end

function [v, b] = train_soft(X, Y, C)

    n = size(X,1);
    H = (Y*Y').*(X*X');
    H = H + eye(n)*1e-7;
    p = repmat(-1,n,1);
    Aeq = Y';
    beq = 0;
    A = -1 * eye(n);  % Flip the normal constraint
    b = repmat(0,n,1);
    LB = repmat(0,n,1);
    UB = repmat(C,n,1);
    %options = optimset('Display','off')
    
    alpha = quadprog(H,p,A,b,Aeq,beq,LB, UB);


    support_vectors = find(alpha>0.01);
    w2summation = (alpha.*Y).*X;
    w = sum(w2summation)';
    
    v = (alpha.*Y);


    Xw = X*w;
    b = mean(Y(support_vectors)-Xw(support_vectors));
    
    w;
    b;
    margin = 1/norm(w);
    sv_alphas = alpha(support_vectors);
end

% function [Xsv] = plot_bound(w, b)
%     xs = xlim;
%     bound_ys = (-b - w(1)*xs)/w(2);
%     marg1_ys = (1 - b - w(1)*xs)/w(2);
%     marg2_ys = (-1 - b - w(1)*xs)/w(2);
%     plot(xs,bound_ys,'b');
%     plot(xs,marg1_ys,'b--');
%     plot(xs,marg2_ys,'b--');
% 
%     Xsv = X(support_vectors,:);
%     plot(Xsv(:,1),Xsv(:,2),'bo','markersize',10);
% end


function [d] = decision(v, b, K_test)
    vs = size(v');
    ks = size(K_test);
    d = v' * K_test' + b;
end

function [K] = polykernel(input, X_tra, param)
     for i = 1:length(input)
         size(input(i,:))
         size(X_tra*input(i,:)')
         
         K(i,:) = (X_tra*input(i,:)' + 1)^param
     end
    
end

function [K] = linkernel(input, X_tra, param)
    size(input);
    size(X_tra);
    
    
    K = X_tra * input';
    
end

