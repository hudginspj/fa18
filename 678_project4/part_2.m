close all
format compact
hold on

KERNELNO = 2

% Data preprocessing
[Y X]=libsvmread('glass');  
X=full(X);
X=normalize(X);
shuffle_idx = randperm(length(Y));
X = X(shuffle_idx,:);
Y = Y(shuffle_idx);

% Run experiment
[vs, bs, ps, cs] = build_classifiers(KERNELNO, X, Y);
cs % Optimum C values
ps % Optimum parameters for each classifier
errors = final_evaluation(KERNELNO, X, Y, vs, bs, ps)

% Specification of kernels and parameters
function [kernel, params, C0] = kernelparams(kernelno)
    if kernelno == 1
        kernel = @linkernel;
        params = [1];
        C0 = [1e-2 1e-1 1 1e1 1e2 1e3 1e4];
    elseif kernelno == 2
        kernel = @grbf_fast;
        params = [1e-2 1e-1 1 1e1 1e2 1e3];
        C0 = [1e-2 1e-1 1 1e1 1e2 1e3 1e4];
    elseif kernelno == 3
        kernel = @polykernel;
        params = [1 2 3 4 5];
        C0 = [1e-2 1e-1 1 1e1 1e2 1e3 1e4];
    end
end


function [ws, bs, ps, cs] = build_classifiers(kernelno, X, Y)
    [kernel, params, C0] = kernelparams(kernelno);
    
    
    bs = [];
    ws = [];
    ps = [];
    cs = [];
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
        k_test = kernel(x, X, ps(i));
        d(i) = decision(v', b, k_test');
    end
    [val, class] = max(d);
end

function [Yi] = transform_y(Y, y_val)
    Yi = (Y==y_val)*2 -1;
end

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

    v = (alpha.*Y);  %As specified in text Equation 2.37
    pred = (v' * G')';
    
    support_vectors = find(alpha>1e-5);
    b = mean(Y(support_vectors)-pred(support_vectors));
end

function [errors, predictions] = score(K_test, Y, v, b)
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
    K = input * X_tra';  
end

