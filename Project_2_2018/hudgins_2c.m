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
gk_size = size(grbf_fast(X_tra, X, 1))

pk_size = size(polykernel(X_tra, X, 2))
lk_size = size(linkernel(X_tra, X, 1))

%[v, b] = train_soft(@polykernel, X, transform_y(Y, 1), 1, 2);

%d = decision(v, b, linkernel(X, X(1,:), 1))
%K_test = polykernel(X, X, 2);
%[errors] = score(K_test, transform_y(Y, 1), v, b)

%[errors] = xval(@grbf_fast, X, transform_y(Y, 5), 1, 1)
%[C, param] = optimize(@grbf_fast, X, Y1, [1e-2 1e-1 1 1e1 1e2 1e3 1e4], [1e-2 1e-1 1 1e1 1e2 1e3])
%[C, param] = optimize(@polykernel, X, Y1, [1], [1 2 3])


[vs, bs, ps, cs] = build_classifiers(3, X, Y);
ps
cs
cs(1)
errors = final_evaluation(3, X, Y, vs, bs, ps)
% for i = 1:10
%     class = prediction(@linkernel, X(i,:), X, vs, bs, ps, unique(Y)')
%     Yi = Y(i)
% end


%G = grbf_fast(X, X, 1)

function [kernel, params] = kernelparams(kernelno)
    if kernelno == 1
        kernel = @linkernel;
        params = [1];
    elseif kernelno == 2
        kernel = @grbf_fast;
        params = [1e-2 1e-1 1 1e1 1e2 1e3];
    elseif kernelno == 3
        kernel = @polykernel;
        params = [1 2 3 4 5]; 
    end
end


function [ws, bs, ps, cs] = build_classifiers(kernelno, X, Y)
    [kernel, params] = kernelparams(kernelno);
    C0 = [1e-2 1e-1 1 1e1 1e2 1e3 1e4];
    
    bs = [];
    ws = [];
    ps = [];
    cs = []
    yvals = unique(Y)';
    for i = yvals
        Yi = transform_y(Y, i);
        [C, param] = optimize(kernel, X, Yi,C0,params)
        cs(i) = C;
        ps(i) = param;
        [ws(i,:), bs(i)] = train_soft(kernel, X, Yi, C, param);
    end
end



function errors = final_evaluation(kernelno, X, Y, vs, bs, ps)
    errors = 0;
    [kernel, params] = kernelparams(kernelno);
    
    for i = 1:length(Y)
        [class] = prediction(kernel, X(i,:), X, vs, bs, ps, unique(Y)');
        actual = Y(i);
        if class ~= actual
            errors = errors +1;
        end
    end
end

function [class] = prediction(kernel, x, X, vs, bs, ps, yvals)
    d = [];
    
    for i = yvals
        v = vs(i,:);
        b = bs(i);
        param = ps(i);  
        k_test = kernel(x, X, ps(i));
        d(i) = decision(v', b, k_test');
        %d(i) = d;
    end
    d;
    [val, class] = max(d);
end

function [Y1] = transform_y(Y, y_val)
    Y1 = (Y==y_val)*2 -1;
end

% function [w, b] = build_classifer(kernel, X, Y, y_val, C0, params)
%     Y1 = transform_y(Y, y_val)
%     [C, param] = optimize(X, Y1,C0,params);
%     [w, b] = train_soft(X, Y1, C);
% end

function [best_C, best_param] = optimize(kernel, X, Y, C0, parameters)
    best_C = -1;
    best_errors = inf;
    best_param = -1;
    for i = 1:length(C0)
        C = C0(i);
        for j = 1:length(parameters)
            param = parameters(j);
            [errors] = xval(kernel, X, Y, C, param);
            if errors < best_errors
                best_errors = errors;
                best_C = C;
                best_param = param;
            end
        end
    end
end

function [errors] = xval(kernel, X, Y, C, param)
    indices = crossvalind('Kfold',length(Y),5);
    errors = 0;
    for i = 1:10
       test = (indices == i);
       tra = ~test;
       [v, b] = train_soft(kernel, X(tra,:), Y(tra), C, param);
       
       K_test = kernel(X(test,:), X(tra,:), param);
       size(K_test);
       errors = errors + score(K_test, Y(test), v, b);
    end
end



function [v, b] = train_soft(kernel, X, Y, C, param)

    n = size(X,1);
    G = kernel(X, X, param);
    H = (Y*Y').*G';
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

    v = (alpha.*Y);
    
    support_vectors = find(alpha>1e-5);
    pred = (v' * G')';
    b = mean(Y(support_vectors)-pred(support_vectors));
%     support_vectors = find(alpha>0.01);
%     w2summation = (alpha.*Y).*X;
%     w = sum(w2summation)';
%     

% 
% 
%     Xw = X*w;
%     b = mean(Y(support_vectors)-Xw(support_vectors));
%     
%     w;
%     b;
%     margin = 1/norm(w);
%     sv_alphas = alpha(support_vectors);
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



function [errors, predictions] = score(K_test, Y, v, b)
    %K_test = kernel(X_test, X_train, param)
    dim = size(K_test);
    predictions = arrayfun(@(i) sign(decision(v, b, K_test(i,:)')), 1:dim(1));
    error_arr = ((predictions'.*Y)-1)/-2;
    errors = sum(error_arr);
end

function [d] = decision(v, b, K_test)
    vs = size(v');
    ks = size(K_test);
    d = v' * K_test + b;
end

function [K] = polykernel(input, X_tra, param)
    K=[];
    for i = 1:size(input, 1)
        xi = input(i,:);
        for j = 1:size(X_tra,1)
             xj = X_tra(j,:);
             xsize = size(xj);
             k = (xi*xj' + 1)^param;
             K(i,j) = k;
        end
    end
    
end

function [K] = linkernel(input, X_tra, param)
    size(input);
    size(X_tra);
    
    
    K = input * X_tra';
    
end

